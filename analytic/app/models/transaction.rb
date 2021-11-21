class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :task

  enum kind: { withdrawal: 'withdrawal', accrual: 'accrual' }
end
