class Transaction < ApplicationRecord
  belongs_to :balance
  belongs_to :task, optional: true
  belongs_to :balance_cycle

  enum kind: { accrual: 'accrual',  withdrawal: 'withdrawal' }
end
