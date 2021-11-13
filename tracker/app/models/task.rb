class Task < ApplicationRecord
  include AASM

  belongs_to :account

  validates_presence_of :title, :description
  validate :title_without_jira_id

  enum status: {
    bird_in_a_cage: 'open',
    millet_in_a_bowl: 'closed'
  }

  aasm(:status) do
    state :bird_in_a_cage, initial: true
    state :millet_in_a_bowl

    event :pour_millet_into_a_bowl do
      transitions from: :bird_in_a_cage, to: :millet_in_a_bowl
    end
  end

  private

  def title_without_jira_id
    if title.include?('[') || title.include?(']')
      errors.add(:title, "can't include '[' or ']'")
    end
  end
end
