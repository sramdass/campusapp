class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_profile
  helper_method :temp_branch  #This has to be removed once the multitenant architecture is in place
  before_filter :mailer_set_url_options  
  before_filter :set_tenant_branch
  
  def set_tenant_branch
    Branch.current = current_profile.branch.id
  end
  
  def current_profile
  #Destroying  a cookie using code just empties the cookie. So just checking for nil is not sufficient.
    if cookies[:auth_token] && !(cookies[:auth_token].empty?)
      @current_profile ||= UserProfile.find_by_auth_token!(cookies[:auth_token])
    else
      nil
    end
  end  
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
  end  
  
  def temp_branch
  	return Branch.first
  end
end
