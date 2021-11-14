class Account < ApplicationRecord
  has_many :tasks
  has_one :balance
  has_many :transactions

  def admin?
    role == 'admin'
  end

  def accountant?
    role == 'accountant'
  end
end
