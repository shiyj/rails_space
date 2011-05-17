require 'test_helper'

class CommunityControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get browse" do
    get :browse
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
