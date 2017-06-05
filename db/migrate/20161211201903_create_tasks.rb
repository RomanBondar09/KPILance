class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :subject
      t.integer :price

      t.timestamps
    end
  end
end
