class AddJiraIdToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :jira_id, :string
  end
end
