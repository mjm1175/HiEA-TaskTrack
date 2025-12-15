require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @project = Project.create!(
      name: "Test Project",
      description: "Sample project"
    )
  end

  test "is valid with valid attributes" do
    task = Task.new(
      project: @project,
      title: "Test task",
      status: "todo",
      priority: 3
    )

    assert task.valid?
  end

  test "is invalid without a title" do
    task = Task.new(
      project: @project,
      status: "todo",
      priority: 3
    )

    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "is invalid without a project" do
    task = Task.new(
      title: "Orphan task",
      status: "todo",
      priority: 3
    )

    assert_not task.valid?
    assert_includes task.errors[:project], "must exist"
  end

  test "status must be in allowed list" do
    task = Task.new(
      project: @project,
      title: "Invalid status task",
      status: "blocked",
      priority: 3
    )

    assert_not task.valid?
    assert_includes task.errors[:status], "is not included in the list"
  end

  test "priority must be between 1 and 5" do
    task = Task.new(
      project: @project,
      title: "Bad priority",
      status: "todo",
      priority: 6
    )

    assert_not task.valid?
    assert_includes task.errors[:priority], "must be less than or equal to 5"
  end

  # -----------------------
  # overdue? method tests
  # -----------------------

  test "not overdue when due date is in the future" do
    task = Task.new(
      project: @project,
      title: "Future task",
      status: "todo",
      priority: 3,
      due_date: Date.today + 2.days
    )

    assert_not task.overdue?
  end

  test "overdue when due date is in the past and status is not done" do
    task = Task.new(
      project: @project,
      title: "Past task",
      status: "in_progress",
      priority: 3,
      due_date: Date.today - 1.day
    )

    assert task.overdue?
  end

  test "not overdue when due date is in the past but status is done" do
    task = Task.new(
      project: @project,
      title: "Completed task",
      status: "done",
      priority: 3,
      due_date: Date.today - 1.day
    )

    assert_not task.overdue?
  end
end
