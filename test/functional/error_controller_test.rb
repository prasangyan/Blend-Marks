require 'test_helper'
require 'authlogic/test_case'

class ErrorControllerTest < ActionController::TestCase

  setup do
  end

  test "check the error handling controller" do

    get :index
    assert_response :success, "Error handling page not opened"
    
  end

end
