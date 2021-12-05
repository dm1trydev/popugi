class TransactionsConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case [payload['event_name'], payload['event_version']]
      when ['Transaction.Completed', 1]
        validation = SchemaRegistry.validate_event(payload, 'transaction.completed', version: 1)
        raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

        create(payload['data'])
      else
        # store in db
      end
    end
  end

  private

  def create(data)
    account = Account.find_by!(public_id: data['owner_public_id'])
    task = Task.find_by!(public_id: data['reason']['task_public_id'])

    params = {
      public_id: data['public_id'],
      amount: data['amount'],
      kind: data['type'],
      reason: data['reason']['description'],
      account_id: account.id,
      task_id: task.id
    }
    Transaction.create!(params)
  end
end

