require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    login_as :quentin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:families)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create families" do
    assert_difference('Family.count') do
      post :create, :families => { }
    end

    assert_redirected_to families_path(assigns(:families))
  end

  test "should show families" do
    get :show, :id => families(:smith).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => families(:smith).to_param
    assert_response :success
  end

  test "should update families" do
    put :update, :id => families(:smith).to_param, :families => { }
    assert_redirected_to families_path(assigns(:families))
  end

  test "should destroy families" do
    assert_difference('Family.count', -1) do
      delete :destroy, :id => families(:smith).to_param
    end

    assert_redirected_to families_path
  end
end
