class TasksChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case [payload['event_name'], payload['event_version']]
      when ['Task.Created', 1]
        validation = SchemaRegistry.validate_event(payload, 'task.created', version: payload['event_version'])

        create(payload['data']) if validation.success?
      else
        # store in db
      end
    end
  end

  private

  def create(data)
    amount = rand(20..40)
    fee = rand(-20..-10)
    task_params = data.to_h.merge(amount: amount, fee: fee, balance_cycle_id: BalanceCycle.current_cycle.id)

    task = Task.create!(task_params)

    event_data = {
      public_id: task.public_id,
      amount: amount,
      fee: fee
    }
    event = Event.new(name: 'Task.PriceSet', data: event_data)
    if SchemaRegistry.validate_event(event.to_json, 'tasks.price_set', version: 1).success?
      Producer.produce_sync(payload: event.to_json, topic: 'tasks')
    end
  end
end
