require 'test_helper'

class ParticipantsControllerTest < ActionController::TestCase
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
    assert_difference('Participants.count') do
      post :create, :participants => { }
    end

    assert_redirected_to participants_path(assigns(:participants))
  end

  test "should show participants" do
    get :show, :id => participants(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => participants(:one).to_param
    assert_response :success
  end

  test "should update participants" do
    put :update, :id => participants(:one).to_param, :participants => { }
    assert_redirected_to participants_path(assigns(:participants))
  end

  test "should destroy participants" do
    assert_difference('Participants.count', -1) do
      delete :destroy, :id => participants(:one).to_param
    end

    assert_redirected_to participants_path
  end
end
