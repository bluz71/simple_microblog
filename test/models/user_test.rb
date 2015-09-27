require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.create(name: "user", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "valid email address tests" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US_ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |email_address|
      @user.email = email_address
      assert @user.valid?, "#{email_address.inspect} should be valid"
    end
  end

  test "invalid email address tests" do
    invalid_addresses = %w[user@example,com USER_at_foo.COM first.last@foo.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |email_address|
      @user.email = email_address
      assert_not @user.valid?, "#{email_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "passwords should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "authenticated? should return false for a user with a nil digest" do
    assert_not @user.authenticated?('')
  end
end
