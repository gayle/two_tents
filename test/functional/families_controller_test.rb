require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

#  fixtures :users, :families, :participants

  def setup
    login_as :quentin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:families)
  end

  test "should sort properly when more than will fit on one page" do
    Factory(:family)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create families" do
    post :create, :commit => 'Save', :family => {:participants_attributes => {
                                                   '0' => { :firstname => 'Foo', :lastname => 'Foo', :birthdate => 10.years.ago.to_date, :state => 'OH', :main_contact => '1'},
                                                   '1' => { :firstname => 'Bar', :lastname => 'Bar', :birthdate => 10.years.ago.to_date, :state => 'OH', :main_contact => '0'}
                                                  }}
    assert_redirected_to families_path
    assert_equal 1, Family.count
    p = Participant.find_by_firstname_and_lastname('Foo','Foo')
    assert_equal 2, p.family.participants.size
  end

  test "should get edit" do
    f = Factory(:family)
    get :edit, :id => f.to_param
    assert_response :success
  end

  test "should update families" do
    p = Factory(:participant)
    f = Factory(:family, :participants => [p])

    participant_attrs = { '12345' => { :firstname => 'Foo', :lastname => 'Bar', :birthdate => "02/04/1975" }}
    put :update, :id => f.to_param, :family => { :participants_attributes => participant_attrs }

    assert Participant.find_by_firstname('Foo')
    assert_redirected_to families_path
  end

  test "should destroy families" do
    5.times do
      Factory(:family)
    end
    f = Factory(:family, :familyname => "space")
    5.times do
      Factory(:family)
    end

    assert_difference('Family.count', -1) do
      delete :destroy, :id => f.to_param
    end

    assert_redirected_to families_path
  end
  
  # This test works but I'm not sure why.
  # When you remove && (attributes['main_contact'] != "1") from models/family.rb
  # the test should fail but it still passes.  Why?
  test "should not set main_contact to nil" do
    p = Factory(:participant, :main_contact => true) 
    f = Factory(:family, :participants => [p])
    assert f.main_contact  # verify we have main_contact set

    # Test 1: simulate main_contact checked on blank entry
    put :update, :id => f.to_param,
      :family => { :participant_attributes => { 
                   '12345' => { :main_contact => "1" },
                   '12346' => { :main_contact => "0", :id => p.id } }}
    assert f.main_contact

    # Test 2: verify db didn't get changed
    assert Family.find_by_id(f.id).main_contact
  end
  
end
