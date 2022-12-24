require 'test_helper'

class UserTest < ActiveSupport::TestCase
 def setup
   @user = User.new(name: "Example", email: "user@example.com", 
                    password: "hardpass", password_confirmation: "hardpass")
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
   @user.name = 'a'*51
   assert_not @user.valid?
 end
 
 test "name should not be too short" do
   @user.name = 'a'
   assert_not @user.valid?
 end
 
  test "email should not be too long" do
   @user.email = 'a'*51 + '@gmail.com'
   assert_not @user.valid?
 end
 
 test "email should not be too short" do
   @user.email = 'a'
   assert_not @user.valid?
 end
 
 test "email should be invalid" do
   invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                        foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
 end 
 
 test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
 end
 
 test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
 end
 
 test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
 end
  
 test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 2
    assert_not @user.valid? 
 end
 
 test "authentificated? should return false for a user with nil digest" do
    assert_not @user.authentificated?(:remember, '')
 end
 
 test "should follow and unfollow user" do
  ed = users(:edward)
  nwl = users(:nwl)
  assert_not ed.following?(nwl)
  ed.follow(nwl)
  assert ed.following?(nwl)
  assert nwl.followers.include?(ed)
  ed.unfollow(nwl)
  assert_not ed.following?(nwl)
 end
end
