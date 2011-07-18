require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "validate user model" do

    user = User.new
    #trying to save with empty values
    assert !user.save , 'User has been saved with empty inputs'

    user.username = "santhosh"
    user.email = "santhoshonet@gmail.com"
    user.group_id = 1
    #trying to save without password field
    assert !user.save, "User has been saved without password field"
    user.password = "password@123"
    #trying to save without confirm_password field
    user.password_confirmation = "password@123"
    #trying to save with proper input
    assert user.save, "User not saved with proper inputs."

    assert_not_nil user.bookmarkletcode, "User bookmarklet code is saved along with user"

    user = User.new
    user.email = "santhosh@itxsolutionsindia.com"
    user.group_id = 1
    user.password = "password@123"
    user.password_confirmation = "password@123"
    #trying to save without username field
    assert !user.save , "User has been saved without username field."
    user.username = "santhosh"
    #trying to save with duplicated username
    assert !user.save , "User has been saved with duplicated username."
    user.username = "santhoshonet"
    user.email = nil
    #trying to save with empty email field
    assert !user.save , "User has been saved with empty email address."
    user.email = "santhoshonet@gmail.com"
    #trying to save with duplicated email address
    assert !user.save, "User has been saved with duplicated email address."
    user.email = "sdajfgdsafjkg@34dsfsfgsdg"
    #trying to save with invalid email address
    assert !user.save, "User has been saved with invalid email address."
    user.email = "santhosh@itxsolutionsindia.com"
    user.group_id = nil
    #trying to save without group value
    assert !user.save , "User has been saved without group field"
    user.group_id = 1
    #trying to save with proper value
    assert user.save, "User is not saved with proper inputs"
    assert_not_nil user.bookmarkletcode, "User bookmarklet code is saved along with user"
    
  end

end