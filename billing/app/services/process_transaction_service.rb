class ProcessTransactionService
  def initialize(transaction, description)
    @transaction = transaction
    @description = description
  end

  def call
    event_data = {
      public_id: transaction.reload.public_id,
      amount: transaction.amount,
      type: transaction.kind,
      owner_public_id: transaction.balance.account.public_id,
      reason: reason
    }
    event = Event.new(name: 'Transaction.Completed', data: event_data)
    validation = SchemaRegistry.validate_event(event.to_h.as_json, 'transaction.completed', version: 1)
    raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

    WaterDrop::SyncProducer.call(event.to_json, topic: 'transactions')
  end

  private

  attr_reader :transaction, :description

  def reason
    result = { description: description }
    result.merge!(task_public_id: transaction.task.public_id) if transaction.task.present?
    result
  end
end
