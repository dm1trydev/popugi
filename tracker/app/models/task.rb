class Task < ApplicationRecord
  include AASM

  belongs_to :account

  validates_presence_of :title, :description

  aasm(:status) do
    state :open, initial: true
    state :closed

    event :close do
      transitions from: :open, to: :closed
    end
  end
end
