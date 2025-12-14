class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: "todo"
      t.date :due_date
      t.integer :priority, null: false, default: 5
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
    add_check_constraint :tasks,
    "status IN ('todo', 'in_progress', 'done')",
    name: "tasks_status_check"

    add_check_constraint :tasks,
    "priority IN (1, 2, 3, 4, 5)",
    name: "tasks_priority_check"
  end
end
