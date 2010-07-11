require 'test_helper'

class ParticipantsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    login_as :quentin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:participants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create participants" do
    assert_difference('Participant.count', 1) do
      post :create, :commit => 'Save',
           :participant => {
                   :family => Family.find(:first),
                   :lastname => "Smith", :firstname => "Joe", :birthdate => '1/1/2000', :state => "OH" }
    end

    assert_redirected_to participants_path
  end

  test "should show participants" do
    p = Factory(:participant)
    get :show, :id => p.to_param
    assert_response :success
  end

  test "should get edit" do
    p = Factory(:participant)
    get :edit, :id => p.to_param
    assert_response :success
  end

  test "should update participant" do
    p = Factory(:participant)
    put :update, :id => p.to_param, :participants => { }
    assert assigns(:participant)
    assert_redirected_to participants_path
  end

  test "should not destroy participants with a user" do
    assert_difference('Participant.count', 0) do
      p = Factory(:participant)
      delete :destroy, :id => p.to_param
    end

    assert_redirected_to participants_path
  end

  test "should destroy participants without a user" do
    p = Factory(:participant)
    assert_difference('Participant.count', -1) do
      delete :destroy, :id => p.to_param
    end

    assert_redirected_to participants_path
  end
end
