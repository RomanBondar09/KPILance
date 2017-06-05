class AddDefaultValueForPhotoUrlAndRatingInUsers < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :photo_url, ''
    change_column_default :users, :rating, 0
  end
end
