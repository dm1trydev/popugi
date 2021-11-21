class TasksChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case [payload['event_name'], payload['event_version']]
      when ['Task.Created', 2]
        validation = SchemaRegistry.validate_event(payload, 'task.created', version: payload['event_version'])
        raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

        create(payload['data'])
      when ['Task.Updated', 1]
        validation = SchemaRegistry.validate_event(payload, 'task.updated', version: payload['event_version'])
        raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

        update(payload['data'])
      else
        # store in db
      end
    end
  end

  private

  def create(data)
    performer = Account.find_by!(public_id: data['performer_public_id'])
    task_params = data.to_h.except('performer_public_id').merge(account_id: performer.id)

    Task.create!(task_params)
  end

  def update(data)
    task = Task.find_by!(public_id: data['public_id'])

    task.update!(fee: data['fee'], amount: data['amount'])
  end
end
