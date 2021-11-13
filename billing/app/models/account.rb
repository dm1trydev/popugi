class Account < ApplicationRecord
  has_many :tasks

  def admin?
    role == 'admin'
  end

  def accountant?
    role == 'accountant'
  end
end
