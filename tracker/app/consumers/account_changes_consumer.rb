class AccountChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case payload['event_name']
      when 'Account.Created'
        create(payload['data'])
      when 'Account.Updated'
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
