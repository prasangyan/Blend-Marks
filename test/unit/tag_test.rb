require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test "validate tag model" do

    tag = Tag.new
    #trying to add with empty tag fields
    assert !tag.save , "Tag has been saved with empty field values"

    tag.name = "some tag name"
    # trying to add with proper value
    assert tag.save, "Tag not saved with proper inputs"

    tag = Tag.new
    tag.name = "some tag name"
    #trying to add with duplicated tag name
    assert !tag.save , "Tag has been saved with duplicated tag name"
    tag.name = "some other name"
    #trying to add with proper value
    assert tag.save, "Tag is not saved with proper inputs."

  end

end