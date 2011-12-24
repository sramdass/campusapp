class SessionsController < ApplicationController
	
  def new
  end

  def create
    profile = UserProfile.find_by_login(params[:login])
    if profile && profile.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = profile.auth_token
      else
        cookies[:auth_token] = profile.auth_token
      end
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to log_in_path, :notice => "Logged out!"
  end

end
