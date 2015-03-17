require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:rafael)
  end

  test "login failure flash" do
    get login_path
    assert_template "sessions/new"
    post login_path, session: { email: "", password: "" }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "success login test" do
    get login_path
    post login_path, session: { email: @user.email, password: "password" }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "user authenticate returns false if user is nil" do
    assert_not @user.authenticated?('')
  end

  test "login with remember" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies["remember_token"]
  end

  test "login without remember" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies["remember_token"]
  end
end
