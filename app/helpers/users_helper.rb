module UsersHelper
  def render_user(user)
    { username: user.username, email: user.email,
      photo_url: user.photo_url, rating: user.rating }
  end
end
