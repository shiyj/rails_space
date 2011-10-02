class ProfileController < ApplicationController
	helper :avatar
  def index
  	@title="RailsSpace Profile"
  end

  def show
  	screen_name=params[:screen_name]
  	@user=User.find_by_screen_name(screen_name)
    @is_profile=true
  	if @user
  		@title="My RailsSpace Profile for #{screen_name}"
  	  make_profile_vars
    else
  		flash[:notice]="No User #{screen_name} at RailsSpace!"
  		redirect_to :action=>"index"
  	end
  end

end
