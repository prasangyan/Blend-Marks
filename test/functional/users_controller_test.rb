require 'test_helper'
require 'authlogic/test_case'

class UsersControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  setup :activate_authlogic
  
  setup do
    @request.host = "test.local.host"
    set_login
  end

  test "check users controller actions" do

    # requesting register page for new user
    get :new
    assert_response :success
    assert assigns(@user)

    # posting values to the new user register page without parameters
    post :create
    assert_response :success
    assert_equal flash[:notice] , 'user credentials not passed.'

    # posting values to the new user register page with new user details
    post :create, :user => {:email => "santhoshonet@gmail.com", :password => "password@123", :password_confirmation => "password@123"}
    assert_response :redirect
    assert_equal flash[:notice] , 'Registration successfully completed.'
    assert_redirected_to :controller => "links", :action => "index"

    assert !User.find_by_username("santhoshonet@gmail.com").nil?

    # posting values to the new user register page with model error values, [ex: repeated email here]
    post :create, :user => {:email => "santhoshonet@gmail.com", :password => "password@123", :password_confirmation => "password@123"}
    assert_response :success
    assert_equal flash[:notice] ,  'Invalid parameter values passed.'
    assert assigns(@user)

    # logout manually
    @controller = UserSessionsController.new
    get :destroy

    # get back the controller to current
    @controller = UsersController.new

    # requesting edit action for user without logged in
    get :edit
    assert_response :redirect
    assert_redirected_to login_url

    # login now
    # posting the log in information
    @controller = UserSessionsController.new
    post :create, :user_session => {:username => "santhosh@itxsolutionsindia.com", :password => "password@123"}
    assert_equal "Successfully logged in.",  flash[:notice].to_s
    assert_redirected_to :controller => "links", :action => "index"

    # now get back to our controller
    @controller = UsersController.new

    # again requesting edit action
    get :edit
    assert_response :success
    assert assigns(@user)

    # requesting/posting update action without passing parameters
    get :update
    assert_response :success
    assert assigns(@user)
    assert_equal flash[:notice] , 'User credentials not passed.'

    # ------ with post
    post :update
    assert_response :success
    assert assigns(@user)
    assert_equal flash[:notice] , 'User credentials not passed.'

    # posting values now
    # posting values with model error values, [ex: repeated email here]
    post :update, :user => {:email => "santhoshonet@gmail.com"}
    assert_response :success
    assert_equal flash[:notice] , 'Invalid parameters passed.'
    assert assigns(@user)

    # posting values with proper values
    post :update, :user => {:email => "santhoshonet@yahoo.com"}
    assert_response :redirect
    assert_equal flash[:notice] , 'Your profile updated successfully.'
    assert_redirected_to :controller => "links", :action => "index"

    #requesting forgot password action
    get :forgotpassword
    assert_response :success

    # parsing parameter [username] to forgot password
    # with invalid username first
    get :forgotpassword, :username => "santhosh@itx.com"
    assert_response :success
    assert_equal assigns(@message)[:error].to_s, "Invalid email address entered!"

    # with avaialable username
    post :forgotpassword, :username => User.first.username
    assert_response :success
    assert_equal assigns(@message)[:error], nil
    assert_equal assigns(@message)[:status].to_s , "An email has been sent to you for resetting your password."

    # requesting success action
    get :success
    assert_response :success
    assert_equal assigns(@message)[:status].to_s, ""

    #requesting reset password without parameters
    get :resetpassword
    assert_response :redirect
    assert_redirected_to :controller => "error", :action => "index"

    #requesting reset password with wrong id
    get :resetpassword, :id => "sadfsadf"
    assert_response :redirect
    assert_redirected_to :controller => "error", :action => "index"

    # manually setting reset_code to the user
    User.first.reset_code = "weur23746234"
    User.first.save

    #requesting reset password with id
    get :resetpassword, :id => User.first.reset_code
    assert_response :success
    assert assigns(@user)
    
    # posting setpassword without parameters
    post :setpassword
    assert_response :redirect
    assert_redirected_to :controller => "error", :action => "index"

    # posting setpassword with only username
    post :setpassword, :username => User.first.username
    assert_response :success
    assert assigns(@user)
    assert_equal assigns(@message)[:status].to_s, ""

    # posting setpassword with only username, password
    post :setpassword, :username => User.first.username, :password => "password@123"
    assert_response :success
    assert assigns(@user)
    assert_equal assigns(@message)[:status].to_s, ""

    # posting setpassword with only username, password, and wrong confirm_password
    post :setpassword, :username => User.first.username, :password => "password@123", :confirm_password => "sdagljhdg"
    assert_response :success
    assert assigns(@user)
    assert_equal assigns(@message)[:status].to_s, ""

    # posting setpassword with only username, password, and confirm_password
    post :setpassword, :username => User.first.username, :password => "password@123", :confirm_password => "password@123"
    assert_response :success
    assert assigns(@user)
    assert_equal assigns(@message)[:status].to_s, "Your password has been modified."

    # requesting user destroy action, without parameter [:id]
    get :destroy
    assert_response :redirect
    assert_redirected_to error_url

    # requesting user destroy action, with wrong parameter [:id]
    get :destroy, :id => 34597
    assert_response :redirect
    assert_redirected_to :controller => "links", :action => "index"

    # requesting user destroy action, with actual parameter [:id]
    get :destroy, :id => User.first.id
    assert_response :redirect
    assert_redirected_to :controller => "links", :action => "index"

    # requesting invitepeople action
    get :invitepeople
    assert_response :success
    assert assigns(@user)

    #requesting confirminvitation without parameter [:email]
    get :confirminvitation
    assert_response :success
    assert @response.body, "invalid parameters passed."

    #requesting confirminvitation with parameter [:email], but only one email
    get :confirminvitation, :email => "santhoshinet@gmail.com"
    assert_response :success
    assert @response.body, "success"

    #requesting confirminvitation with parameter [:email], with multiple emails
    get :confirminvitation, :email => "santhoshinet@gmail.com,santhoshanet@gmail.com,santhoshenet@gmail.com,santhoshunet@gmail.com"
    assert_response :success
    assert @response.body, "success"
    
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