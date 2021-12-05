class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.uuid :public_id, null: false
      t.decimal :amount, null: false
      t.string :kind, null: false
      t.string :reason
      t.references :account, foreign_key: true
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
