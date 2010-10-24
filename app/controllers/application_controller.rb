# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time (for views)

  # explicitly including lets controllers see a helper too
  include SessionsHelper

  # SSL support
  #include SslRequirement

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

end
