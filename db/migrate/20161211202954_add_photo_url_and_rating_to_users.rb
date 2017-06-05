class AddPhotoUrlAndRatingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :photo_url, :string
    add_column :users, :rating, :integer
  end
end
