require 'test_helper'

class NotificationlinkTest < ActiveSupport::TestCase

  test "validate Notification link model" do

    nlink = Notificationlink.new

    # trying to save without values
    assert !nlink.save, "Notifications saved with empty values"

    nlink.link = 'http://gmail.com'
    # trying to save with actual values
    assert nlink.save , "Notification link is not saved."

    nlink = Notificationlink.new
    nlink.link = 'http://gmail.com'
    #trying to save with duplicated value
    assert !nlink.save, "Duplicated notification link is saved."

  end

end