class UserMailer < ActionMailer::Base
  default :from => "gis.zzu@163.com"
  def welcome(user)
  	@user=user
  	mail(:to=>@user.email)
  end
  def sendtome
    mail(:to=>"syj1syj1@163.com")
  end
end
