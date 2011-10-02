# encoding: utf-8
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
    #保护页面函数
  def protect
    unless logged_in?
      #友好的转向页面
      session[:protected_page]=request.fullpath
      flash[:notice]="Please log in first"
      redirect_to :action=>"login"
      #return false是打断往下的链,即before_filter往下执行的内容
      #这就是before_filter的功效.
      return false
    end
  end
  #作为全局方法来让不同的controller之间统一到user上。DRY
  def make_profile_vars
   @spec=@user.spec || Spec.new
   @faq=@user.faq || Faq.new
   @blog= @user.blog || Blog.new
   @posts= @blog.posts.paginate(:page=>params[:page],:per_page=>10) 
  end
end
