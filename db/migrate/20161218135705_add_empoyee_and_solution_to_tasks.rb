class AddEmpoyeeAndSolutionToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :employee_id, :integer
    add_column :tasks, :solution, :boolean
  end
end
