require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar" }
      }
    end
    assert_template 'users/new'
  end
  
  test "valid signup with account activation" do
    get signup_path
    assert_difference 'User.count',1 do 
      post users_path, params: { user: {
        name: "Example User",
        email: "user@example.com",
        password: "foo",
        password_confirmation: "foo" }
      }
    end
   assert_equal 1, ActionMailer::Base.deliveries.size
   user = assigns(:user) # deprecated method!
   assert_not user.activated?
   log_in_as(user)
   assert_not is_logged_in?
   get edit_account_activation_path(user.activation_token, email: 'wrong')
   assert_not is_logged_in?
   get edit_account_activation_path(user.activation_token, email: user.email)
   assert user.reload.activated?
   follow_redirect!
   assert_template 'users/show'
   assert is_logged_in?
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: "ggwge",
        email: "user@lpnu.ua",
        password: "foo",
        password_confirmation: "foo" }
      }
    end
    follow_redirect!
    # assert_template 'users/show'
    # assert is_logged_in?
  end
  
end
