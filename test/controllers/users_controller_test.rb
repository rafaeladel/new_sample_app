require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should index redirect to login" do
    get :index
    assert_redirected_to login_url
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

  test "get edit if its own user" do
    log_in_as(@user)
    get :edit, id: @user
    assert_template 'users/edit'
  end

  test "redirect get to root if not your own edit" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_redirected_to root_url
  end

  test "redirect patch to root if not your own edit" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: "test", email: "test@test.com" }
    assert_redirected_to root_url
  end

  test "delete for non logged in user" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "delete for non admin user" do
    log_in_as @other_user
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to users_url
  end

  test "delete for admin user" do
    log_in_as @user
    assert_difference 'User.count', -1 do
      delete :destroy, id: @other_user
    end
    assert_redirected_to users_url
  end


end
