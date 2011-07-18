require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test "validate group model" do

    g = Group.new
    # validating with null values
    assert !g.save, "Group model saves with null values"
    g.title = "group title 1"
    # validating with proper values
    assert g.save, "Group model not saved"
    g = Group.new
    g.title = "group title 1"
    # validating with repeated group title

    assert !g.save, "Group model saved with repeated title"

    
  end

end