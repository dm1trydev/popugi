class AddBalanceCycleReferenceToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :balance_cycle, index: true
  end
end
