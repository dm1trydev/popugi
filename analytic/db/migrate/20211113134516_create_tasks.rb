class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.uuid :public_id, null: false
      t.string :title
      t.string :jira_id
      t.text :description
      t.string :status
      t.decimal :fee
      t.decimal :amount
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
