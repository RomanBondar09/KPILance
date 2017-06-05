class AddNameToAttachmentFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :attachment_files, :name, :string
  end
end
