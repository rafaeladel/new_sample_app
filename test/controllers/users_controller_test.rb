require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:rafael)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "redirect on get edit" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "redirect on patch edit" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end



end
