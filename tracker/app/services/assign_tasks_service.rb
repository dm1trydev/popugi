class AssignTasksService
  class << self
    def call(tasks, accounts)
      tasks.each { |task| assign_to_account(task, accounts.sample) }
    end

    private

    def assign_to_account(task, account)
      task.account = account
      return unless task.save

      # BE + CUD events
      event_data = {
        public_id: task.public_id,
        performer_public_id: account.public_id
      }
      event = ::Event.new(name: 'Task.Assigned', data: event_data)

      validation = SchemaRegistry.validate_event(event.to_h.as_json, 'task.assigned', version: 1)
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks') if validation.success?

      NotifyTaskAssigneeService.call(task)
    end
  end
end
