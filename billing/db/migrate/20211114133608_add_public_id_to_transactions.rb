class AddPublicIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :public_id, :uuid, default: 'gen_random_uuid()', null: false
  end
end
