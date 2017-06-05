class LoginsController < ApplicationController

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      log_in(user)
      render json: render_user(user), status: :ok
    else
      render json: {error: 'error'}, status: :bad_request
    end
  end

  def destroy
    if logged_in?
      log_out
      render nothing: true, status: :ok
    else
      render json: {error: 'error'}, status: :bad_request
    end
  end
end
