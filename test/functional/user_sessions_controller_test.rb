require 'test_helper'
require 'authlogic/test_case'

class UserSessionsControllerTest < ActionController::TestCase
    include Authlogic::TestCase
    setup :activate_authlogic

  setup do

      @request.host = "test.local.host"
      set_login
    
  end

  test "check user session controller actions" do

      # to log out if its logged in with another test controller
      # check logout page
      get :destroy
      assert_response :success
      assert assigns(@user_session)

      # check login page
      get :new
      assert_response :success
      assert assigns(@user_session)
      
      # check logout page
      get :destroy
      assert_response :success
      assert assigns(@user_session)

      # posting logging in action without values
      post :create
      assert_response :success
      assert assigns(@usersession)
      assert_equal flash[:notice].to_s,"user credentials not found."

      # posting logging action with wrong inputs
      post :create, :user_session => {:username => "santhosh@itxsolutionsindia.com"}
      assert_response :success
      assert assigns(@usersession)
      assert_equal flash[:notice].to_s,"invalid parameters passed."

      # posting logging action with valid inputs
      post :create, :user_session => {:username => "santhosh@itxsolutionsindia.com", :password => "password@123"}
      assert_response :redirect
      assert assigns(@current_user)
      assert_redirected_to :controller => "links", :action => "index"

  end

   def set_login
        group = Group.new
        group.title = "test"
        if group.save
          user = group.user.new
          user.username = "santhosh@itxsolutionsindia.com"
          user.email = "santhosh@itxsolutionsindia.com"
          user.password = "password@123"
          user.password_confirmation = "password@123"
          user.isnotificationsubscribed = true
          user.bookmarkletcode = User.random_string(10)
          unless user.save
            puts user.errors.full_messages()
          end
        end
        user = UserSession.create(:username => "santhosh@itxsolutionsindia.com", :password => "password@123", :remember_me => true)
        unless user.save
          puts user.errors.full_messages()
        end
        assert user.save, "User session not saved."
   end
  
end