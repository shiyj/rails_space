class SpecController < ApplicationController
  def edit
  	@title="编辑用户模型"
  	@user=User.find(session[:user_id])
  	@user.spec ||=Spec.new
  	@spec=@user.spec
  	if param_posted?(:spec)
  		if @user.spec.update_attributes(params[:spec])
  			flash[:notice]="更新成功!"
  			redirect_to :controller=>"user",:action=>"index"
  		end
  	end
  end

end
