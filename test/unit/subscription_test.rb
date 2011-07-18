require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase

  test "validate subscription model" do

    sub = Subscription.new

    #trying to save with null values
    assert !sub.save, "Subscription is saved with empty values"

    sub.email = "sadfhsadfsadf"
    #trying to save with invalid email address
    assert !sub.save , "Invalid email is saved in Subscription"

    sub.email = "santhoshonet@gmail.com"
    #trying to save with actual values
    assert sub.save, "Subscription is not saved with actual values."

    sub = Subscription.new
    sub.email = "santhoshonet@gmail.com"
    #trying to save with duplicated email address
    assert !sub.save , "Subscription was saved with duplicated email address"
    sub.email = "santhosh@itxsolutionsindia.com"
    #trying to save with actual values
    assert sub.save, "Subscription is not saved with actual values"

  end

end