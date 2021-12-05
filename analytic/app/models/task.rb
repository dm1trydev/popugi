class Task < ApplicationRecord
  belongs_to :account
  has_many :transactions

  enum status: { bird_in_a_cage: 'bird_in_a_cage', millet_in_a_bowl: 'millet_in_a_bowl' }
end
