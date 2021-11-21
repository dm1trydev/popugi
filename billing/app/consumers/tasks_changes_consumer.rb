class TasksChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case [payload['event_name'], payload['event_version']]
      when ['Task.Created', 2]
        validation = SchemaRegistry.validate_event(payload, 'task.created', version: payload['event_version'])
        raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

        create(payload['data'])
      else
        # store in db
      end
    end
  end

  private

  def create(data)
    Task.transaction do
      amount = rand(20..40)
      fee = rand(10..20)
      performer = Account.find_by!(public_id: data['performer_public_id'])

      task_params = data.to_h.except('performer_public_id')
      task_params = task_params.merge(amount: amount,
                                      fee: fee,
                                      account_id: performer.id,
                                      balance_cycle_id: BalanceCycle.current_cycle.id)

      task = Task.create!(task_params)

      event_data = {
        public_id: task.public_id,
        amount: amount,
        fee: fee
      }
      event = Event.new(name: 'Task.Updated', data: event_data)

      validation = SchemaRegistry.validate_event(event.to_json, 'task.updated', version: 1)
      raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')
    end
  end
end
