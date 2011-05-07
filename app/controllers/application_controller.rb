class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  before_filter :check_authorization
  def check_authorization
    request.session_options[:session_key]= '_engin_rails_space_session_id'
    authorization_token=cookies[:authorization_token]
    if cookies[:authorization_token] and not logged_in?
      user=User.find_by_authorization_token(:authorization_token)
      user.login!(session) if user
    end
  end
   #验证表单是否提交
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
end
