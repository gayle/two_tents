require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration" do
    assert_difference('Registration.count') do
      post :create, :registration => { }
    end

    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should show registration" do
    get :show, :id => registrations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => registrations(:one).to_param
    assert_response :success
  end

  test "should update registration" do
    put :update, :id => registrations(:one).to_param, :registration => { }
    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should destroy registration" do
    assert_difference('Registration.count', -1) do
      delete :destroy, :id => registrations(:one).to_param
    end

    assert_redirected_to registrations_path
  end
end
