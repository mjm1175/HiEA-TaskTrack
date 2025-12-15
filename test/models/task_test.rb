require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    # Create a unique project for each test to avoid uniqueness violations
    @project = Project.create!(name: "Project #{SecureRandom.hex(4)}")
  end

  test "valid with title, status, priority, and project" do
    task = Task.new(title: "Test Task", status: "todo", priority: 3, project: @project)
    assert task.valid?
  end

  test "invalid without title" do
    task = Task.new(status: "todo", priority: 2, project: @project)
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "invalid with status outside allowed values" do
    task = Task.new(title: "Task", status: "invalid_status", priority: 2, project: @project)
    assert_not task.valid?
    assert_includes task.errors[:status], "is not included in the list"
  end

  test "invalid with priority <1 or >5" do
    task = Task.new(title: "Task", status: "todo", priority: 0, project: @project)
    assert_not task.valid?

    task.priority = 6
    assert_not task.valid?
  end

  test "invalid without project" do
    task = Task.new(title: "Task", status: "todo", priority: 3)
    assert_not task.valid?
    assert_includes task.errors[:project], "must exist"
  end

  test "#overdue? returns false if due_date in future" do
    task = Task.new(title: "Future", status: "todo", priority: 3, project: @project, due_date: Date.tomorrow)
    assert_not task.overdue?
  end

  test "#overdue? returns true if due_date past and status not done" do
    task = Task.new(title: "Overdue", status: "in_progress", priority: 2, project: @project, due_date: Date.yesterday)
    puts "DEBUG: Task due_date: #{task.due_date}, current date: #{Date.current}, status: #{task.status}, overdue?: #{task.overdue?}"
    assert task.overdue?
  end

  test "#overdue? returns false if due_date past but status done" do
    task = Task.new(title: "Done Task", status: "done", priority: 1, project: @project, due_date: Date.yesterday)
    assert_not task.overdue?
  end
end
