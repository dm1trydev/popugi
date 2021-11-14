class TasksController < ApplicationController
  before_action :authenticate!
  before_action :set_task, only: [:show, :destroy, :pour_millet_into_a_bowl]
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
        jira_id: @task.jira_id,
        title: @task.title,
        description: @task.description,
        status: @task.status
      }
      event = ::Event.new(name: 'Task.Created', data: event_data, version: 2)

      validation = SchemaRegistry.validate_event(event.to_h.as_json, 'task.created', version: 2)
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream') if validation.success?

      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def catch_birds
    CatchBirdService.call(Task.bird_in_a_cage, Account.all)

    redirect_to tasks_path, notice: 'Bird caged.'
  end

  def my
    @tasks = Task.where(account_id: current_account.id)
  end

  def pour_millet_into_a_bowl
    if @task.may_pour_millet_into_a_bowl? && @task.pour_millet_into_a_bowl!
      # BE + CUD events
      event = Event.new(name: 'Task.MilletPoured', data: { public_id: @task.public_id })

      validation = SchemaRegistry.validate_event(event.to_h.as_json, 'task.millet_poured', version: 1)
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks') if validation.success?

      redirect_to @task, notice: 'Millet poured into a bowl.'
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
    params.require(:task).permit(:jira_id, :title, :description)
  end

  def can_assign_tasks?
    current_account&.admin? || current_account&.manager?
  end
  helper_method :can_assign_tasks?
end
