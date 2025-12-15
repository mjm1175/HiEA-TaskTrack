class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [ :destroy, :edit, :update, :show ]
  before_action :ensure_json_request, only: [ :index ]    # index route JSON only

  # json only route
  def index
    @tasks = @project.tasks

    # Status filter
    if params[:status].present?
      @tasks = @tasks.with_status(params[:status])
    end

    # Overdue
    if params[:overdue].present?
      @tasks = @tasks.overdue if params[:overdue] == "true"
    end

    # Force JSON render
    render json: @tasks
  end

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

  def ensure_json_request
    Rails.logger.debug "ensure_json_request called, format: #{request.format}"
    return if request.format.json?
    render json: { error: "JSON requests only" }, status: 406
  end
end
