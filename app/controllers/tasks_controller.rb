class TasksController < ApplicationController
  before_action :set_project

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    Rails.logger.info "Creating task with params: #{task_params.inspect}"


    if @task.save
      Rails.logger.info "Task saved successfully"
      redirect_to @project, notice: "Task created successfully!"
    else
      # render the same form with errors
      Rails.logger.info "@task class: #{@task.class.name}, errors: #{@task.errors.full_messages.inspect}"
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :priority)  # add other fields as needed
  end
end
