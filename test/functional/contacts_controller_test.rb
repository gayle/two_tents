require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, :contact => {:name => "test", :email => "some@email.com", :subject => "just testing", :comment => "yay!" }
    end

    assert_redirected_to root_path
  end
end
