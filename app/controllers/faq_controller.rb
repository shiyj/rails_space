# encoding: utf-8
class FaqController < ApplicationController
  before_filter :protect
  def edit
  	@title="Edit FAQ"
  	@user=User.find(session[:user_id])
  	@user.faq ||=Faq.new
  	@faq=@user.faq
  	if param_posted?(:faq)
  		if @user.faq.update_attributes(params[:faq])
  			flash[:notice]="FAQ 更新成功!"
  			redirect_to :controller=>"user",:action=>"index"
  		end
  	end
  end

end
