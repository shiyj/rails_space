require 'test_helper'

class UserControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :users
  def setup
  	@controller=UserController.new
  	@requst=ActionController::TestRequest.new
  	@response=ActionController::TestResponse.new
  	@valid_user=users(:valid_user)
  end
  #测试保护大页面
  test "index unauthorized" do
    get:index
    assert_response :redirect
    assert_redirected_to :action=>"login"
    assert_equal "Please log in first",flash[:notice]
  end
  #同时将本来的连接测试更改
  test "should get index" do
    authorize @valid_user
    get :index
    title=assigns(:title)
    assert_equal "RailsSpace User Hub",title
    assert_response :success
  end

  test "should get register" do
    get :register
    assert_response :success
    #assert_tag "form",:attributes=>{:action=>"/user/register",:method=>"post"}
    assert_form_tag "/user/register"
    #assert_tag "input",      :attributes=>{:name=>"user[screen_name]",        :type=>"text",        :size=>User::SCREEN_NAME_SIZE,        :maxlength=>User::SCREEN_NAME_MAX_LENGTH}
    assert_screen_name_field
    #assert_tag "input",      :attributes=>{:name=>"user[password]",        :type=>"password",        :size=>User::PASSWORD_SIZE,        :maxlength=>User::PASSWORD_MAX_LENGTH}
    assert_password_filed
    #assert_tag "input",      :attributes=>{:name=>"user[email]",        :type=>"text",        :size=>User::EMAIL_SIZE,        :maxlength=>User::EMAIL_MAX_LENGTH}
    assert_email_field
    #assert_tag "input",:attributes=>{:type=>"submit",:value=>"Register!"}
  end
  
  test "registration success" do
    post :register,:user=>{
                    :screen_name=>"new_screen_name",
                    :email=>"valid@aaa.com",
                    :password=>"long_enough_password"}
    #测试指定的用户
    user=assigns(:user)
    assert_not_nil user
    new_user=User.find_by_screen_name_and_password(user.screen_name,user.password)
    assert_equal new_user,user
    assert_equal "User #{new_user.screen_name} created!",flash[:notice]
    assert_redirected_to :action=>"index"
    #确定用户完成登录操作
    assert_not_nil logged_in?
    assert_equal user.id,session[:user_id]
  end
  
  test "logout" do
    try_to_login @valid_user,:remember_me=>"0"
    assert_not_nil logged_in?
    get :logout
    assert_response :redirect
    assert_redirected_to :action=>"index",:controller=>"site"
    assert_equal "Logged out",flash[:notice]
    assert_nil logged_in?
  end
  
  test "login failed whith nonexisten screen_name" do
    invalid_user=@valid_user
    invalid_user.screen_name="no such user"
    try_to_login invalid_user ,:remember_me=>"0"
    assert_template "login"
    assert_equal "Invalid screen name/password combination",flash[:notice]
    user=assigns(:user)
    assert_equal invalid_user.screen_name,user.screen_name
    assert_nil user.password
  end
  
  test "navigation logged in" do
    authorize @valid_user
    get :index
    assert_tag "a",:content=>/Logout/,:attributes=>{:href=>"/user/logout"}
    assert_no_tag "a",:content=>/Register/
    assert_no_tag "a",:content=>/Login/
  end
  
  test "login friendly" do
    get:index
    assert_response :redirect
    assert_redirected_to :action=>"login"
    try_to_login @valid_user,:remember_me=>"0"
    assert_response :redirect
    assert_redirected_to :action=>"index"
    assert_nil session[:protected_page]
  end
  
  test "register friendly" do
    get:index
    assert_response :redirect
    assert_redirected_to :action=>"login"
    post :register,:user=>{ :screen_name=>"new_screen_name",
                            :email=>"valid@aaa.com",
                            :password=>"tttttttttttttttttttt"}
    assert_response :redirect
    assert_redirected_to :action=>"index"
    assert_nil session[:protected_page]
  end
  
  test "login_success" do
    try_to_login @valid_user,:remember_me=>"0"
    assert_not_nil logged_in?
    assert_equal @valid_user.id,session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in!",flash[:notice]
    assert_response :redirect
    assert_redirected_to :action=>"index"
    #没有选中remember_me的情况
    user=assigns(:user)
    assert user.remember_me!="1"
    #没有cookie集
    assert_nil cookies[:remember_me]
    assert_nil cookies[:authorization_token]
  end
  
  test "login success with remember me" do
    try_to_login @valid_user,:remember_me=>"1"
    test_time=Time.now
    assert logged_in?
    assert_equal @valid_user.id,session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in!",flash[:notice]
    assert_response :redirect
    assert_redirected_to :action=>"index"
    #检查cookies和过期时间
    user=User.find(@valid_user.id)
    #remember_me cookies
    assert_equal "1",cookies["remember_me"]
    #assert_equal 10.years.from_now(test_time),cookies["remember_me"].expires
    #身份验证cookie
    cookie_token = cookies[:authorization_token]
    assert_equal user.authorization_token,cookies["authorization_token"]
    #assert_equal 10.years.from_now(test_time),cookie_expires(:authorization_token)
  end
  
  test "edit page" do
  	authorize @valid_user
  	get :edit
  	title =assigns(:title)
  	assert_equal "Edit basic info",title
  	assert_response :success
  	assert_template "edit"
  	assert_form_tag "/user/edit"
  	assert_email_field @valid_user.email
  	assert_password_filed "current_password"
  	assert_password_filed
  	assert_password_filed "password_confirmation"
  	assert_submit_button "Update"
  end
  ###########################################
  #以下为函数定义部分
  ###########################################
  
  private
  def try_to_login(user,options={})
    user_hash={:screen_name=>user.screen_name,
                       :password=>user.password }
    user_hash.merge!(options)
    post:login,:user=>user_hash
    
  end
  
  #authorize只是在session中标记以方便测试
  #之所以不使用tyr_to_login是因为它可能成功也可能不成功
  #故而在单项测试中不能太多耦合
  def authorize(user)
    @request.session[:user_id]=user.id
  end
  #简化断言方式,只是视图上的判断,不牵涉验证信息.
  def assert_email_field(email=nil,options={})
  	assert_input_field("user[email]",email,"text",User::EMAIL_SIZE,User::EMAIL_MAX_LENGTH,options)
  end
  def assert_password_filed(password_field_name="password",options={})
  	blank=nil
  	assert_input_field("user[#{password_field_name}]",blank,"password",User::PASSWORD_SIZE,User::PASSWORD_MAX_LENGTH,options)
  end
  def assert_screen_name_field(screen_name=nil,options={})
  	assert_input_field("user[screen_name]",screen_name,"text",User::SCREEN_NAME_SIZE,User::SCREEN_NAME_MAX_LENGTH,options)
  end
end
