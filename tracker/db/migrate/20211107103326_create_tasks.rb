class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.uuid :public_id, default: 'gen_random_uuid()', null: false
      t.string :title
      t.text :description
      t.string :status
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
