class AddDefaultForSolutionInTasks < ActiveRecord::Migration[5.0]
  def change
    change_column_default :tasks, :solution, false
  end
end
