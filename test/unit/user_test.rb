require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  def test_should_create_user
    assert_difference 'User.count' do
      user = Factory(:user)
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :login => nil)
      u.save
      assert u.errors.get(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :password => nil)
      u.save
      assert u.errors.get(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :password_confirmation => nil)
      u.save
      assert u.errors.get(:password_confirmation)
    end
  end

  def test_should_require_security_question
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :security_question => nil)
      u.save
      assert u.errors.get(:security_question)
    end
  end

  def test_should_require_security_answer
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :security_answer => nil)
      u.save
      assert u.errors.get(:security_answer)
    end
  end

  def test_should_reset_password
    u = Factory(:user)
    assert u.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal u, User.authenticate(u.login, 'new password')
  end

  def test_should_not_rehash_password
    u = Factory(:user, :password=>'monkey', :password_confirmation=>'monkey')
    assert u.update_attributes(:login => 'quentin2')
    assert_equal u, User.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_user
    Factory(:single_user)
    u = User.find_all_by_login('quire').first
    assert_equal u, User.authenticate('quire', 'quire69')
  end

  def test_should_set_remember_token
    u = Factory(:single_user)
    u.remember_me
    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
  end

  def test_should_unset_remember_token
    u = Factory(:single_user)
    u.remember_me
    assert_not_nil u.remember_token
    u.forget_me
    assert_nil u.remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc

    u = Factory(:single_user)
    u.remember_me_for 1.week

    after = 1.week.from_now.utc

    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
    assert u.remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc

    u = Factory(:single_user)
    u.remember_me_until time
    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
    assert_equal u.remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    u = Factory(:single_user)
    u.remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
    assert u.remember_token_expires_at.between?(before, after)
  end
end
