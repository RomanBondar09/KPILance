class CreateAssignTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :assign_tasks do |t|
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end
  end
end
