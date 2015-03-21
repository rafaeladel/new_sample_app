require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'example@example.com', password: 'mypassword', password_confirmation: 'mypassword')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '  '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test 'name length shouldn\'t be greater than 50' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'name length shouldn\'t be greater than 250' do
    @user.email = 'a' * 251
    assert_not @user.valid?
  end

  test 'test email formate is valid' do
    valid_emails = %w[mail@mail.com user@test.com toto@lolo.com]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test 'test email formate is not valid' do
    valid_emails = %w[mail@mail userssstest.com tololo.com]
    valid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should not be valid"
    end
  end

  test 'email downcasing' do
    email = "RAF@mail.com"
    @user.email = email
    @user.save
    assert_equal email.downcase, @user.email
  end

  test 'unique email' do
    duplicated_user = @user.dup
    @user.save
    assert_not duplicated_user.valid?
  end

  test 'minimum password length' do
    @user.password = @user.password_confirmation = 'a' * 5
    @user.save
    assert_not @user.valid?
  end

  test "user deleting deletes related microposts" do
    @user.save
    @user.microposts.create!(content: "ttdwdw dwd")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

end
