require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    login_as(:admin)
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_allow_edit
    user = User.find(:first)
    get :edit, :id => user.id
    participants = assigns :participants
    assert_equal(true, participants.include?(user.participant))
  end

  def test_should_update_user
    user = User.find(:first)
    participant = Participant.find(:first)
    put :update, {:id => user.id, :user => { :participant_id_attr => participant.id, :login => "changedlogin" }}
    assert_response :redirect
    user.reload
    assert_equal participant, user.participant
    assert_equal 'changedlogin', user.login
  end


  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69', :participant_id_attr => Participant.find(:first),
        :security_question => 'question', :security_answer => 'answer'
      }.merge(options)
    end
end
