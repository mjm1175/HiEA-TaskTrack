require "test_helper"

class TasksApiTest < ActionDispatch::IntegrationTest
  setup do
    @project = Project.create!(name: "API Project #{SecureRandom.hex(4)}")
    @task1 = Task.create!(title: "Task 1", status: "todo", priority: 2, project: @project, due_date: Date.yesterday)
    @task2 = Task.create!(title: "Task 2", status: "done", priority: 1, project: @project, due_date: Date.yesterday)
    @task3 = Task.create!(title: "Task 3", status: "in_progress", priority: 3, project: @project, due_date: Date.tomorrow)
  end

  test "returns all tasks as JSON" do
    get api_project_tasks_url(@project)
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 3, json.size
    titles = json.map { |t| t["title"] }
    assert_includes titles, "Task 1"
    assert_includes titles, "Task 2"
    assert_includes titles, "Task 3"
  end

  test "filters tasks by status" do
    get api_project_tasks_url(@project), params: { status: "todo" }
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 1, json.size
    assert_equal "Task 1", json.first["title"]
  end

  test "filters only overdue tasks with overdue=true" do
    get api_project_tasks_url(@project), params: { overdue: true }
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 1, json.size
    assert_equal "Task 1", json.first["title"]
    assert_equal true, json.first["overdue"]
  end
end
