class AddEstimateToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :estimate, :integer
  end
end
