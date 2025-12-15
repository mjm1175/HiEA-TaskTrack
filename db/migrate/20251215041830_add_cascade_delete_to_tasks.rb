class AddCascadeDeleteToTasks < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :tasks, :projects

    add_foreign_key :tasks, :projects, on_delete: :cascade
  end
end
