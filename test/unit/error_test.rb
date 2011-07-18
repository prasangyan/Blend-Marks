require 'test_helper'

class ErrorTest < ActiveSupport::TestCase

  test "validate error model" do

    err = Error.new

    #validating without passing values
    assert !err.save, "Error model accepting null values"

    err.title = "some title here"

    #validating with proper values
    assert err.save, "Error model not saved with proper value"

    err = Error.new
    err.title = "some title here"

    #validating with repeated title value
    assert !err.save, "Error model accepted repeated title"

  end

end