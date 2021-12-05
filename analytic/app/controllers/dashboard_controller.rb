class DashboardController < ApplicationController
  before_action :calculate_income_and_poor_parrots

  def index
    @most_expensive_task = most_expensive_task
  end

  private

  def calculate_income_and_poor_parrots
    @top_management_income = 0
    @poor_parrots_count = 0

    Account.preload(:transactions).find_each do |account|
      transactions = account.transactions.select do |transaction|
        transaction.created_at > Time.current.beginning_of_day && transaction.created_at < Time.current
      end

      sum = transactions.sum { |transaction| transaction.withdrawal? ? -transaction.amount : transaction.amount }
      if sum < 0
        @top_management_income += -sum
        @poor_parrots_count += 1
      end
    end
  end

  def most_expensive_task
    task = Task

    task = case params[:period]
           when 'week'
             task.where(updated_at: Time.current.beginning_of_week..Time.current)
           when 'month'
             task.where(updated_at: Time.current.beginning_of_month..Time.current)
           else
             task.where(updated_at: Time.current.beginning_of_day..Time.current)
           end

    task.millet_in_a_bowl.maximum(:amount)
  end
end
