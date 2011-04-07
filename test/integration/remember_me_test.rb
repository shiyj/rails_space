require 'test_helper'

class RememberMeTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  fixtures :users
  
  def setup
    @user=users(:valid_user)
  end
  test "remember me" do
    #启用remember me时的登录,把user参数传入.
    post "user/login",:user=>{:screen_name=>@user.screen_name,:password=>@user.password,:remember_me=>"1"}
    #模拟浏览器关闭.将session清空.
    @request.session[:user_id]="aaaa"
    get "sit/index"
    assert logged_in?
    assert_equal @user.id,session[:user_id]
  end
  
end
