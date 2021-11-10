class NotifyTaskAssigneeService
  def self.call(task)
    account_id = task.account_id

    Rails.logger.info("Email to account #{account_id} sent")
    Rails.logger.info("Sms to account #{account_id} sent")
    Rails.logger.info("Message to slack to account #{account_id} sent")
  end
end
