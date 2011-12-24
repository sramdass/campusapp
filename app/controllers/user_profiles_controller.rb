class UserProfilesController < ApplicationController
  def new
    @title = 'Sign Up'
    @profile = UserProfile.new
  end

  def create
  	#Make sure the 'login' field value corresponds to a Faculty's or student's id_no
    user = Faculty.find_by_id_no(params[:user_profile][:login])
    if user
      @profile = UserProfile.new(params[:user_profile])
      @profile.user=user
      if @profile.save
        flash[:notice] = "Welcome #{user.name}!"
        redirect_to root_path
      else
        render :new
      end
    else
      flash[:error] =  "Unable to sign up. Please contact the admin to add your profile"
      redirect_to sign_up_path
    end
  end
end