class AccountChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case [payload['event_name'], payload['event_version']]
      when ['Account.Created', 1]
        validation = SchemaRegistry.validate_event(payload, 'account.created', version: payload['event_version'])
        raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

        create(payload['data'])
      when ['Account.Updated', 1]
        validation = SchemaRegistry.validate_event(payload, 'account.updated', version: payload['event_version'])
        raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

        update(payload['data'])
      else
        # store event in DB
      end
    end
  end

  private

  def create(data)
    find_account(data) || Account.create!(data)
  end

  def update(data)
    account = find_account(data)
    return if account.blank?

    account.full_name = data['full_name']
    account.save!
  end

  def find_account(data)
    Account.find_by_public_id(data['public_id'])
  end
end
