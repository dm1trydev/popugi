class Account < ApplicationRecord
  has_many :tasks

  def admin?
    role == 'admin'
  end
end
