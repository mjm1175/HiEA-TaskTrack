require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # Setup a project to avoid uniqueness/association issues
  def setup
    @project = Project.create!(name: "Test Project #{SecureRandom.hex(4)}")
  end

  # -----------------------
  # Validations
  # -----------------------

  test "valid with all required attributes" do
    task = Task.new(
      title: "Sample Task",
      status: "todo",
      priority: 3,
      project: @project
    )
    assert task.valid?
  end

  test "invalid without title" do
    task = Task.new(
      title: nil,
      status: "todo",
      priority: 3,
      project: @project
    )
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "invalid without status" do
    task = Task.new(
      title: "Task",
      status: nil,
      priority: 3,
      project: @project
    )
    assert_not task.valid?
    assert_includes task.errors[:status], "is not included in the list"
  end

  test "invalid with status not in allowed list" do
    task = Task.new(
      title: "Task",
      status: "waiting",
      priority: 3,
      project: @project
    )
    assert_not task.valid?
    assert_includes task.errors[:status], "is not included in the list"
  end

  test "invalid without priority" do
    task = Task.new(
      title: "Task",
      status: "todo",
      priority: nil,
      project: @project
    )
    assert_not task.valid?
    assert_includes task.errors[:priority], "is not included in the list"
  end

  test "invalid with priority out of range" do
    task_low = Task.new(title: "Task", status: "todo", priority: 0, project: @project)
    task_high = Task.new(title: "Task", status: "todo", priority: 6, project: @project)
    [ task_low, task_high ].each do |task|
      assert_not task.valid?
      assert_includes task.errors[:priority], "is not included in the list"
    end
  end

  test "invalid without project" do
    task = Task.new(title: "Task", status: "todo", priority: 3, project: nil)
    assert_not task.valid?
    assert_includes task.errors[:project], "must exist"
  end

  # -----------------------
  # overdue? method
  # -----------------------

  test "#overdue? returns false for future due date" do
    task = Task.new(
      title: "Future",
      status: "in_progress",
      priority: 2,
      project: @project,
      due_date: Date.tomorrow
    )
    assert_not task.overdue?
  end

  test "#overdue? returns true if due date past and status not done" do
    task = Task.new(
      title: "Overdue",
      status: "in_progress",
      priority: 2,
      project: @project,
      due_date: Date.yesterday
    )
    assert task.overdue?
  end

  test "#overdue? returns false if due date past but status done" do
    task = Task.new(
      title: "Completed",
      status: "done",
      priority: 2,
      project: @project,
      due_date: Date.yesterday
    )
    assert_not task.overdue?
  end
end
