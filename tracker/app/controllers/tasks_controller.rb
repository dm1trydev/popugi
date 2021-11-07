class TasksController < ApplicationController
  before_action :authenticate!
  before_action :set_task, only: [:show, :destroy, :close]
  before_action :can_assign_tasks?, only: :assign_tasks

  # GET /tasks
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  def create
    @task = Task.new(task_params.merge(account_id: Account.all.sample.id))

    if @task.save
      # CUD event
      event_data = {
        public_id: @task.reload.public_id,
        title: @task.title,
        description: @task.description,
        status: @task.status
      }
      event = ::Event.new(name: 'Task.Created', data: event_data)
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')

      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def assign_tasks
    AssignTasksService.call(Task.open, Account.all)

    redirect_to tasks_path, notice: 'Tasks assigned.'
  end

  def my
    @tasks = Task.where(account_id: current_account.id)
  end

  def close
    if @task.may_close? && @task.close!
      # BE + CUD events
      event = Event.new(name: 'Task.Closed', data: { public_id: @task.public_id })
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks')

      redirect_to @task, notice: 'Task closed.'
    else
      render :show
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description)
  end

  def can_assign_tasks?
    current_account&.admin? || current_account&.manager?
  end
  helper_method :can_assign_tasks?
end
