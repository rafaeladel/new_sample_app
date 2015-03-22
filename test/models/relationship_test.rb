require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should be invalid when follower is nil" do
    @relationship.follower = nil
    assert_not @relationship.valid?
  end

  test "should be invalid when followed is nil" do
    @relationship.followed = nil
    assert_not @relationship.valid?
  end
end
