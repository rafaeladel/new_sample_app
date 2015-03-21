require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "test content")
  end

  test "micropost is valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "  "
    assert_not @micropost.valid?
  end

  test "content should be less than 140 char" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "assert first micropost is the most recent one" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
