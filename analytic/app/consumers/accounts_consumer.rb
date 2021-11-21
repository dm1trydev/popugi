class AccountsConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case [payload['event_name'], payload['event_version']]
      when ['Account.RoleChanged', 1]
        validation = SchemaRegistry.validate_event(payload, 'account.role_changed', version: payload['event_version'])
        raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

        change_role(payload['data'])
      else
        # store event in DB
      end
    end
  end

  private

  def change_role(data)
    account = Account.find_by_public_id(data['public_id'])
    return if account.blank?

    account.role = data['role']
    account.save!
  end
end
