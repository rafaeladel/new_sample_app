require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  test "redirect if follow when not logged in" do
    assert_no_difference "Relationship.count" do
      post :create
    end
    assert_redirected_to login_url
  end

  test "redirect if unfollow when not logged in" do
    assert_no_difference "Relationship.count" do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end
