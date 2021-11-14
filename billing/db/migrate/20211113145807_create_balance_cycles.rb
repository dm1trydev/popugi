class CreateBalanceCycles < ActiveRecord::Migration[5.2]
  def change
    create_table :balance_cycles do |t|
      t.string :state, null: false, default: 'open', index: true
      t.datetime :opened_at, null: false
      t.datetime :closed_at

      t.timestamps
    end
  end
end
