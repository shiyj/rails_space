class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_authorization
  session :session_key=> '_engin_rails_space_session_id'
  def check_authorization
    authorization_token=cookies[:authorization_token]
    if cookies[:authorization_token] and not logged_in?
      user=User.find_by_authorization_token(:authorization_token)
      user.login!(session) if user
    end
  end
end
