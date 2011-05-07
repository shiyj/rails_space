require 'test_helper'

class SpecControllerTest < ActionController::TestCase
	fixtures :users
	fixtures :specs
	def setup
		@controller=SpecController.new
		@request=ActionController::TestRequest.new
		@response=ActionController::TestResponse.new
		@user=users(:valid_user)
		@spec=specs(:valid_spec)
	end
  test "should get edit" do
    get :edit
    assert_response :success
  end

end
