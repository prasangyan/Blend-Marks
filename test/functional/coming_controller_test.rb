require 'test_helper'
require 'authlogic/test_case'

class ComingControllerTest < ActionController::TestCase

  setup do
  end

  test "check coming controller actions" do

    get :index
    assert_response :success, "Error occurred on blendmarks home page "
    assert_not_nil assigns(@subscription), "subscription session variable not assigned."
    assert_nil assigns(@message)[:message], "Message is not cleared for index."
    assert !assigns(@message)[:success], "success message is assigned for index."

    # posting nil email value
    post :subscribe , :email => nil
    assert_response :success , "Error occurred on posting the value"
    assert !assigns(@message)[:success], "nil email value accepted"
    assert(assigns(@message)[:message].to_s != "Thank you. We will send you an update as soon as we are ready","nil email value accepted")

    #posting invalid email value
    post :subscribe , :email => "sdafsadf"
    assert_response :success , "Error occurred on posting the value"
    assert !assigns(@message)[:success], "invalid email value accepted"
    assert(assigns(@message)[:message].to_s != "Thank you. We will send you an update as soon as we are ready","invalid email value accepted")

    #posting invalid email value
    post :subscribe , :email => "sdafsadf@dkfgjhdsfg"
    assert_response :success , "Error occurred on posting the value"
    assert !assigns(@message)[:success], "invalid email value accepted"
    assert(assigns(@message)[:message].to_s != "Thank you. We will send you an update as soon as we are ready","invalid email value accepted")

    #posting valid email value
    post :subscribe , :email => "santhoshonet@gmail.com"
    assert_response :success , "Error occurred on posting the value"
    assert assigns(@message)[:success], "Subscription not sent."
    assert(assigns(@message)[:message].to_s == "Thank you. We will send you an update as soon as we are ready","Subscription not sent.")

    #posting duplicated email value
    post :subscribe , :email => "santhoshonet@gmail.com"
    assert_response :success , "Error occurred on posting the value"
    assert !assigns(@message)[:success], "Subscription is sent for duplicated email addresses"
    assert(assigns(@message)[:message].to_s != "Thank you. We will send you an update as soon as we are ready","Subscription is sent for duplicated email addresses")
    
    
  end

end