class ChangeAttachmentFiles < ActiveRecord::Migration[5.0]
  def change
    change_table :attachment_files do |t|
      t.remove :name
      t.integer :task_id
    end
  end
end
