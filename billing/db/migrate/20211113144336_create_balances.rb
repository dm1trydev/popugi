class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.decimal :amount, default: 0
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
