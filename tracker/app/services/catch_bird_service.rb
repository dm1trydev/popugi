class CatchBirdService
  class << self
    def call(tasks, accounts)
      tasks.each { |task| catch_a_bird(task, accounts.sample) }
    end

    private

    def catch_a_bird(task, account)
      task.account = account
      return unless task.save

      # BE + CUD events
      event_data = {
        public_id: task.public_id,
        performer_public_id: account.public_id
      }
      event = ::Event.new(name: 'Task.BirdCaught', data: event_data)

      validation = SchemaRegistry.validate_event(event.to_h.as_json, 'task.bird_caught', version: 1)
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks') if validation.success?

      NotifyTaskAssigneeService.call(task)
    end
  end
end
