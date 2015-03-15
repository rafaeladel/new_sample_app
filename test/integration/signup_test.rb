require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest

  test "test sign up page" do
    get signup_path
    assert_select "title", full_title("Signup")
  end

  test 'failed signup' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: '', email: 'rafael@dw.com', password: '123', password_confirmation: '213' }
    end
    assert_template 'users/new'

    assert_select "#error_explanation li.error_element"
  end

  test 'successful signup' do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: 'fofo', email: 'fofo@fofo.com', password: 'fofopassword', password_confirmation: 'fofopassword' }
    end
    assert is_logged_in?
    assert_template 'users/show'
    assert_not flash.nil?
  end

end
