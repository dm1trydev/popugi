class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.uuid :public_id, default: 'gen_random_uuid()', null: false
      t.string :title
      t.string :jira_id
      t.text :description
      t.string :status
      t.references :account, foreign_key: true
      t.decimal :amount, default: 0
      t.decimal :fee, default: 0

      t.timestamps
    end
  end
end
