class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false
      t.string :kind, null: false
      t.references :balance, foreign_key: true
      t.references :balance_cycle, foreign_key: true
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
