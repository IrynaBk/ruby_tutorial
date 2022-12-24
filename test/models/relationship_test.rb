require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @relationship = Relationship.new(followed_id: users(:edward).id,
                                     follower_id: users(:nwl).id)
  end
  
  test "should be valid" do
    assert @relationship.valid?
  end
  
end
