require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest

  test "test sign up page" do
    get signup_path
    assert_select "title", /Signup .+/
  end

end
