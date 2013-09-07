ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'

class ActiveSupport::TestCase
    if !$FACTORIES_INITIALIZED
      $FACTORIES_INITIALIZED = true
      # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md
      FactoryGirl.find_definitions
    end

  # Was using transactional fixtures before.  Do I still need to do this?
  #   self.use_transactional_fixtures = true

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    @request.session[:user_id] = user ? (user.is_a?(User) ? user.id : users(user).id) : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'monkey') : nil
  end


end
