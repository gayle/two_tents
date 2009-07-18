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
    assert_difference('Participant.count') do
      post :create, :participants => { }
    end

    assert_redirected_to participant_path(assigns(:participants))
  end

  test "should show participants" do
    get :show, :id => participants(:quentin).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => participants(:quentin).to_param
    assert_response :success
  end

  test "should update participant" do
    put :update, :id => participants(:quentin).to_param, :participants => { }
    assert assigns(:participants)
    assert_redirected_to participant_path(assigns(:participants))
  end

  test "should destroy participants" do
    assert_difference('Participant.count', -1) do
      delete :destroy, :id => participants(:quentin).to_param
    end

    assert_redirected_to participants_path
  end
end
