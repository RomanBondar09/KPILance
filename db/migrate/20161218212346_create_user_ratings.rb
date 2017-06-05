class CreateUserRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_ratings do |t|
      t.integer :user_sender_id
      t.integer :user_recipient_id
      t.timestamps
    end
  end
end
