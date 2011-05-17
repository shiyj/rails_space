class AvatarController < ApplicationController
  def upload
  	@title="上传头像"
  	@user=User.find(session[:user_id])
  	if param_posted?(:avatar)
  		image=params[:avatar][:image]
  		@avatar=Avatar.new(@user,image)
  		if @avatar.save
	  		flash[:notice]="头像上传成功!"
  			redirect_to :controller=>"user",:action=> "index"		
  		else
  			flash[:notice]="上传失败!"
  		end
  	end
  end

  def delete
  	user=User.find(session[:user_id])
  	user.avatar.delete
  	flash[:notice]="删除完成."
  	redirect_to :controller=>"user",:action=> "index"		
  end

end
