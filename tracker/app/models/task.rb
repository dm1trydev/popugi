class Task < ApplicationRecord
  include AASM

  belongs_to :account

  validates_presence_of :title, :description
  validate :title_without_jira_id

  aasm(:status) do
    state :open, initial: true
    state :closed

    event :close do
      transitions from: :open, to: :closed
    end
  end

  private

  def title_without_jira_id
    if title.include?('[') || title.include?(']')
      errors.add(:title, "can't include '[' or ']'")
    end
  end
end
