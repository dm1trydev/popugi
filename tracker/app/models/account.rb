class Account < ApplicationRecord
  has_many :tasks

  validates :email, presence: true, uniqueness: true

  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end
end
