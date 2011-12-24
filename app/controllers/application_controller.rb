class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_profile  
  def current_profile
  #Destroying  a cookie using code just empties the cookie. So just checking for nil is not sufficient.
    if cookies[:auth_token] && !(cookies[:auth_token].empty?)
      @current_profile ||= UserProfile.find_by_auth_token!(cookies[:auth_token])
    else
      nil
    end
  end  
end
