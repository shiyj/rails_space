class UserMailer < ActionMailer::Base
  default :from => "gis.zzu@163.com"
  def welcome(user)
  	@user=user
  	mail(:to=>@user.email)
  end
end
