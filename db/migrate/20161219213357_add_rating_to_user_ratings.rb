class AddRatingToUserRatings < ActiveRecord::Migration[5.0]
  def change
    add_column :user_ratings, :rating, :integer
  end
end
