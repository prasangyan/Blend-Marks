require 'test_helper'

class LinkTest < ActiveSupport::TestCase

  test "validate link model" do

    link = Link.new
    #validating with null values
    assert !link.save, "Link is adding with null values"

    link.title = "some title"
    link.link = "http://gmail.com"
    link.tag_id = 1
    link.group_id = 1
    link.user_id = 1

    # validating with proper values
    assert link.save, "Link is not added with proper values"


    link = Link.new
    link.link = "http://gmail.com"
    link.tag_id = 1
    link.group_id = 1
    link.user_id = 1
    # trying to add link without title
    assert !link.save, "Link added without Title field"

    link.title = "some title here"
    link.link = ""
    # trying to add link without title
    assert !link.save, "Link added without Link field"

    link.link = "http://google.com"
    link.tag_id = nil
    # trying to add link without tag_id
    assert !link.save, "Link added without tag field"

    link.tag_id = 1
    link.group_id = nil
    # trying to add link without group_id
    assert !link.save, "Link added without group field"

    link.group_id = 1
    link.user_id = nil
    # trying to add link without user_id
    assert !link.save, "Link added without user field"

    link.user_id = 1
    link.link = "http://gmail.com"
    # trying to add repeated link value
    assert !link.save, "Link added with duplicated link url"

    link.link = "http://santhoshonet.com"
    assert link.save , "Link is not added with proper values"

    assert Notificationlink.count > 0, "Notification link is not added when we add a link"

  end

end