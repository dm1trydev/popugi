class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  enum role: {
    employee: 'employee',
    manager: 'manager',
    admin: 'admin',
    accountant: 'accountant',
    top_manager: 'top_manager'
  }

  after_create do
    reload
    # CUD event
    event_data = {
      public_id: public_id,
      email: email,
      role: role
    }

    event = ::Event.new(name: 'Account.Created', data: event_data)

    validation = SchemaRegistry.validate_event(event.to_h.as_json, 'account.created', version: 1)
    raise StandardError, "Event validation failed:\n#{validation.failure.join("\n")}" if validation.failure?

    Producer.produce_sync(payload: event.to_json, topic: 'accounts-stream')
  end
end
