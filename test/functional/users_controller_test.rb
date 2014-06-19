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
      assert assigns(:user).errors[:login]
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
#      require 'pry'; binding.pry
      assert assigns(:user).errors[:password]
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors[:password_confirmation]
      assert_response :success
    end
  end

  def test_should_allow_edit
    #user = User.find(:first)
    user = Factory(:user)
    get :edit, :id => user.id
    participants = assigns :participants
    assert_equal(true, participants.include?(user.participant))
  end

  def test_should_update_user
    user = Factory(:user)
    participant = user.participant
    put :update, {:id => user.id, :user => { :participant_attributes => 
      { :id => participant.id, :firstname => 'FOO' }, :login => "changedlogin" }}

    assert_response :redirect

    user.reload
    assert_equal 'FOO', user.participant(true).firstname
    assert_equal 'changedlogin', user.login
  end

  def test_new_user_should_have_staff_role
    create_user
    assert assigns(:user).has_role?("staff")
  end

  def test_new_user_should_have_admin_role_if_desired
    create_user(:admin_role => '1')
    assert assigns(:user).has_role?("admin")
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69',
        :security_question => 'question', :security_answer => 'answer',
        :participant_attributes => { :firstname => 'Quire', :lastname => 'Quire', :birthdate => 18.years.ago.to_date.to_s,
                                     :state => 'OH' }
      }.merge(options)
    end
end

