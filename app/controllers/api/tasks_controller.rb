module Api
  class TasksController < ApplicationController
    # json only route
    def index
        project = Project.find(params[:project_id])

        # Start with all tasks for this project
        tasks = project.tasks

        # Status filter
        if params[:status].present?
          tasks = tasks.with_status(params[:status])
        end

        # Overdue
        if params[:overdue].present?
          tasks = tasks.overdue if params[:overdue] == "true"
        end

        # Render JSON
        render json: tasks.map { |task|
          {
            id: task.id,
            title: task.title,
            status: task.status,
            priority: task.priority,
            due_date: task.due_date,
            overdue: task.overdue?
          }
        }
    end
  end
end
