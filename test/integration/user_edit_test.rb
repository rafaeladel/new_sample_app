require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: {
                              name: "",
                              email: "foo@invalid",
                              password: "toto",
                              password_confirmation: "wwww" }

    assert_template 'users/edit'
  end

  test "friendly forward" do
    get edit_user_url(@user)
    assert_redirected_to login_url
    log_in_as @user
    assert_redirected_to edit_user_url(@user)
    log_out_user
    assert_redirected_to root_url
    log_in_as @user
    assert_redirected_to @user
  end

  test "successful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "rafaelo"
    email = "rafael@rafael.com"
    patch user_path(@user), user: { name: name, email: email, password: "", password_confirmation: "" }
    assert_not flash.empty?, 'flash must not be empty'
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

end