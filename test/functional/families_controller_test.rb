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
      post :create, :commit => 'Save', :family => {:participants_attributes => {
                                                     '0' => { :firstname => 'Foo', :lastname => 'Foo', :birthdate => 10.years.ago.to_date, :state => 'OH', :main_contact => '1'},
                                                     '1' => { :firstname => 'Bar', :lastname => 'Bar', :birthdate => 10.years.ago.to_date, :state => 'OH', :main_contact => '0'}
                                                  }}
      assert_redirected_to families_path
    end
    p = Participant.find_by_firstname_and_lastname('Foo','Foo')
    assert_equal p, p.family.main_contact
    assert_equal 2, p.family.participants.size
  end

  test "should get edit" do
    get :edit, :id => families(:space).to_param
    assert_response :success
  end

  test "should update families" do
    put :update, :id => families(:space).to_param, :family => { :participants_attributes => { '12345' => { :firstname => 'Blah', :id => 1 }}}
    assert families(:space).participants(true).find_by_firstname('Blah')
    assert_redirected_to families_path
  end

  test "should destroy families" do
    assert_difference('Family.count', -1) do
      delete :destroy, :id => families(:space).to_param
    end

    assert_redirected_to families_path
  end
  
  test "should not destroy main_contact" do
    put :update, :id => families(:space).to_param, :family => { :participants_attributes => { '12345' => { :main_contact => "1" }}}
    assert families(:space).main_contact
  end
  
end
