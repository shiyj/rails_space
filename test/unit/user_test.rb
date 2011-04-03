require 'test_helper'
require 'active_record'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :users
  def setup
  	@valid_user=users(:valid_user)
  	@invalid_user=users(:invalid_user)
  end
  test "the valid user" do
  	assert @valid_user.valid? 
  end
  
  test "the invalid user" do
  	assert !@invalid_user.valid?
  end
  
  test "the uniqueness of screen_name and email" do
  	user_repeat =User.new(:screen_name=>	@valid_user.screen_name,
  												:email			=>	@valid_user.email,
  												:password		=>	@valid_user.password)
  	assert !user_repeat.save
  	assert !user_repeat.valid?
  	assert_equal ["has already been taken"],user_repeat.errors[:screen_name]
  	assert_equal ["has already been taken"],user_repeat.errors[:email]
  end
  
end
