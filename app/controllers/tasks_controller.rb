class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [ :destroy, :edit, :update, :show ]

  def show
    @task = Task.find(params[:id])
  end

  # Nested project routes
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

  # GET /projects/1/edit
  def edit
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @project, notice: "Task was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to @project, notice: "Task was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end


  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :priority)  # add other fields as needed
  end
end
