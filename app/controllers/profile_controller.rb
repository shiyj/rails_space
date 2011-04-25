class ProfileController < ApplicationController
  def index
  	@title="RailsSpace Profile"
  end

  def show
  	screen_name=params[:screen_name]
  	@user=User.find_by_screen_name(screen_name)
  	if @user
  		@title="My RailsSpace Profile for #{screen_name}"
  	else
  		flash[:notice]="No User #{screen_name} at RailsSpace!"
  		redirect_to :action=>"index"
  	end
  end

end
