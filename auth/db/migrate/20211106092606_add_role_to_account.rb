class AddRoleToAccount < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE account_roles AS ENUM ('employee', 'manager', 'admin', 'accountant', 'top_manager');
    SQL

    add_column :accounts, :role, :account_roles, null: false, default: 'employee'
  end

  def down
    remove_column :accounts, :role

    execute <<-SQL
      DROP TYPE account_roles;
    SQL
  end
end
