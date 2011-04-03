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
    assert_tag "form",:attributes=>{:action=>"/user/register",:method=>"post"}
    assert_tag "input",
      :attributes=>{:name=>"user[screen_name]",
        :type=>"text",
        :size=>User::SCREEN_NAME_SIZE,
        :maxlength=>User::SCREEN_NAME_MAX_LENGTH}
    assert_tag "input",
      :attributes=>{:name=>"user[password]",
        :type=>"password",
        :size=>User::PASSWORD_SIZE,
        :maxlength=>User::PASSWORD_MAX_LENGTH}
    assert_tag "input",
      :attributes=>{:name=>"user[email]",
        :type=>"text",
        :size=>User::EMAIL_SIZE,
        :maxlength=>User::EMAIL_MAX_LENGTH}
    assert_tag "input",:attributes=>{:type=>"submit",:value=>"Register!"}
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
    try_to_login @valid_user
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
    try_to_login invalid_user
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
    try_to_login @valid_user
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
    try_to_login @valid_user
    assert_not_nil logged_in?
    assert_equal @valid_user.id,session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in!",flash[:notice]
    assert_redirected_to :action=>"index"
  end
  ###########################################
  #以下为函数定义部分
  ###########################################
  
  private
  def try_to_login(user)
    post:login,:user=>{:screen_name=>user.screen_name,
                       :password=>user.password }
  end
  
  #authorize只是在session中标记以方便测试
  #之所以不使用tyr_to_login是因为它可能成功也可能不成功
  #故而在单项测试中不能太多耦合
  def authorize(user)
    @request.session[:user_id]=user.id
  end  
  
end
