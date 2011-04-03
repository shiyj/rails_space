require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

  test "test navigation not logged in" do
    get :index
    assert_tag "a",:content=>/Register/,
                   :attributes=>{:href=>"/user/register"}
    assert_tag "a",:content=>/Login/,
                   :attributes=>{:href=>"/user/login"}
    assert_no_tag "a",:content=>/Home/
  end
end
