require 'digest/sha1'
class UserController < ApplicationController
  include ApplicationHelper
  before_filter :protect,:only=>:index
  def index
    @title="RailsSpace User Hub"
  end

  def register
    @title="Register"
    if param_posted?(:user)
      @user=User.new(params[:user])
      if @user.save
	      @user.login!(session)
        flash[:notice]="User #{@user.screen_name} created!"
        redirect_to_forwarding_url
      else
        flash[:notice]="User #{@user.screen_name} created failed!"
        @user.clear_password!
      end
    end
  end
  
  def login
    @title="Login to RailsSpace"
    if request.get?
      @user=User.new(:remember_me=>cookies[:remember_me]||"0")
    else param_posted?(:user)
    	@user=User.new(params[:user])
    	user=User.find_by_screen_name_and_password(@user.screen_name,@user.password)
    	if user
    		user.login!(session)
    		if @user.remember_me=="1"
    		  cookies[:remember_me]={:value=>"1",:expires=>10.years.from_now}
    		  user.authorization_token=Digest::SHA1.hexdigest("#{user.screen_name}:#{user.password}")
    		  user.save!
    		  cookies[:authorization_token]={:value=>user.authorization_token,:expires=>10.years.from_now}
    		else
    		  cookies.delete(:remember_me)
    		  cookies.delete(:authorization_token)
    		end
    		flash[:notice]="User #{user.screen_name} logged in!"
    		redirect_to_forwarding_url
    	else
    		@user.clear_password!
    		flash[:notice]="Invalid screen name/password combination"
    	end
    end
  end
  
  def logout
    User.logout!(session,cookies)
    flash[:notice]="Logged out"
    redirect_to :action=>"index",:controller=>"site"
  end
  
  private
  #保护页面函数
  def protect
    unless logged_in?
      #友好的转向页面
      session[:protected_page]=request.request_uri
      flash[:notice]="Please log in first"
      redirect_to :action=>"login"
      #return false是打断往下大链,即before_filter往下执行大内容
      #这就是before_filter的功效.
      return false
    end
  end
  #验证表单是否提交
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
  #友好转向,重定向到先前的页面
  def redirect_to_forwarding_url
    #友好的转向页面
    #注意:if块内是赋值语句,然后才执行判断.
    #ruby中只有false和nil表示"非"
    if(redirect_url=session[:protected_page])
    	 session[:protected_page]=nil
    	 redirect_to redirect_url
    else
    		redirect_to:action=>"index"
    end
  end
end
