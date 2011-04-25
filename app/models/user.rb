class User < ActiveRecord::Base
  attr_accessor :remember_me
  attr_accessor :current_password
  SCREEN_NAME_MIN_LENGTH=4
  SCREEN_NAME_MAX_LENGTH=20
  PASSWORD_MIN_LENGTH=4
  PASSWORD_MAX_LENGTH=20
  EMAIL_MAX_LENGTH=50
  SCREEN_NAME_RANGE=SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE=PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  #唯一性测试
  SCREEN_NAME_SIZE=20
  PASSWORD_SIZE=20
  EMAIL_SIZE=30
  validates_uniqueness_of :screen_name,:email
  validates_confirmation_of :password
  validates_length_of:screen_name, :within=>SCREEN_NAME_RANGE
  validates_length_of:password,:within=>PASSWORD_RANGE
  validates_length_of:email,:maximum=>EMAIL_MAX_LENGTH
  
  #字符验证
  validates_format_of  :screen_name,
                      :with=>/^[A-Z0-9_]*$/i,
                      :message=>"must contain only letters,numbers,and underscores"
  validates_format_of  :email,
                      :with=>/^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                      :message=>"must be a valid email address"  
  def login!(session)
    session[:user_id]=id
  end
  
  def self.logout!(session,cookies)
    session[:user_id]=nil
    cookies.delete(:authorization_token)
  end
  
  def clear_password!
    self.password=nil
    self.password_confirmation=nil
    self.current_password=nil
  end
  
  def remember!(cookies)
    cookies[:remember_me]={:value=>"1",:expires=>10.years.from_now}
    		  self.authorization_token=Digest::SHA1.hexdigest("#{screen_name}:#{password}")
    		  save!
    		  cookies[:authorization_token]={:value=>authorization_token,:expires=>10.years.from_now}
  end
  
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end
  
  #验证修改密码时提交的原始密码是否正确
  def current_password?(params)
  	current_password=params[:user][:current_password]
  	password==current_password
  	#puts 'hello world'
		#puts current_password
  	#puts password
  end
  def password_errors(params)
  	self.password=params[:user][:password]
  	self.password_confirmation=params[:user][:password_confirmation]
  	valid?
  	errors.add(:current_password,"不正确")
  end
end
