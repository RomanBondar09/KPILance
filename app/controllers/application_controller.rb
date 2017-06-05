class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: ->{request.format.json?}
  include LoginsHelper
  include UsersHelper
  include TasksHelper
end
