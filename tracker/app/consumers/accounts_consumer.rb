class AccountsConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case payload['event_name']
      when 'Account.RoleChanged'
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
