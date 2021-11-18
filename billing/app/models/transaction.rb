class Transaction < ApplicationRecord
  belongs_to :balance
  belongs_to :task

  enum kind: { accrual: 'accrual',  withdrawal: 'withdrawal' }
end
