class BalanceCycle < ApplicationRecord
  cattr_accessor :current

  has_many :transactions

  enum state: { open: 'open', closed: 'closed' }

  validates :closed_at, presence: true, if: :closed?
  before_create :can_be_only_one_open_cycle

  before_create do
    self.opened_at = Time.current
  end

  def self.current_cycle
    self.current ||= (open.first || create)
  end

  private

  def can_be_only_one_open_cycle
    return if self.class.open.count.zero?

    errors.add(:only_one_open_cycle, 'can be only one open cycle at the moment')
  end
end
