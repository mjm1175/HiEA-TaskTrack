require "test_helper"

class Api::TasksRequestTest < ActionDispatch::IntegrationTest
  def setup
    @project = Project.create!(
      name: "API Project",
      description: "Project for API tests"
    )

    @todo_task = Task.create!(
      project: @project,
      title: "Todo task",
      status: "todo",
      priority: 1,
      due_date: Date.today + 3.days
    )

    @overdue_task = Task.create!(
      project: @project,
      title: "Overdue task",
      status: "in_progress",
      priority: 2,
      due_date: Date.today - 2.days
    )

    @done_task = Task.create!(
      project: @project,
      title: "Done task",
      status: "done",
      priority: 3,
      due_date: Date.today - 5.days
    )
  end

  test "returns all tasks for a project as JSON" do
    get api_project_tasks_path(@project)

    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 3, json.length

    titles = json.map { |t| t["title"] }
    assert_includes titles, "Todo task"
    assert_includes titles, "Overdue task"
    assert_includes titles, "Done task"
  end

  test "filters tasks by status" do
    get api_project_tasks_path(@project), params: { status: "todo" }

    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json.length
    assert_equal "todo", json.first["status"]
    assert_equal "Todo task", json.first["title"]
  end

  test "filters only overdue tasks when overdue=true" do
    get api_project_tasks_path(@project), params: { overdue: "true" }

    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json.length

    task = json.first
    assert_equal "Overdue task", task["title"]
    assert_equal true, task["overdue"]
  end
end
