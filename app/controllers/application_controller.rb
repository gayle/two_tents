# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ApplicationHelper # Shouldn't have to do this. But at one point started getting errors in sublcasses of application controller that they didn't know about methods that re defined in application helper, and this fixed it.'
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

#  filter_parameter_logging :password

  layout :choose_layout
  def choose_layout
    if request.xhr?
      false
    else
      request.path =~ /^\/admin\// ? "application" : "homepage"
    end
  end
end
