class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :full_name
      t.string :role
      t.uuid :public_id, index: true

      t.timestamps
    end
  end
end
