class MakeProjectsNameNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :projects, :name, false
  end
end
