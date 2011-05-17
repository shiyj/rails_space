require 'digest/sha1'
class UserController < ApplicationController
  include ApplicationHelper
  helper :profile,:avatar
  before_filter :protect,:only=>:index
  def index
    @title="RailsSpace User Hub"
    @user=User.find(session[:user_id])
    @user.spec ||= Spec.new
    @spec=@user.spec
    @user.faq ||= Faq.new
    @faq=@user.faq
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
    #如果是通过限制访问的页面转向到登录界面则验证cookies.
    if request.get?
      @user=User.new(:remember_me=>cookies[:remember_me]||"0")
    #如果是通过提交表单则执行下边程序.
    elsif param_posted?(:user)
    	@user=User.new(params[:user])
    	user=User.find_by_screen_name_and_password(@user.screen_name,@user.password)
    	if user
    		user.login!(session)
    		if @user.remember_me=="1"
    		  user.remember!(cookies)
    		else
    		  user.forget!(cookies)
    		end
    		flash[:notice]="User #{user.screen_name} logged in!"
    		UserMailer.welcome(user).deliver
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
  
  def edit
  	@title="Edit basic info"
  	@user=User.find(session[:user_id])
  	if param_posted?(:user)
  		if @user.current_password?(params)
				if @user.update_attributes(params[:user])
					flash[:notice]="Information have been updated!"
					redirect_to :action=>"index"
				end
			else
				puts @user.current_password
				@user.password_errors(params)
			end
  	end
  	@user.clear_password!
  end
  
  private
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
