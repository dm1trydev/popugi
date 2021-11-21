class Account < ApplicationRecord
  has_many :tasks
  has_many :transactions

  def admin?
    role == 'admin'
  end
end
