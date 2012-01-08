class UserProfilesController < ApplicationController
  skip_before_filter :set_tenant_branch
  
  def index
  	@user_profiles=UserProfile.all
  end
  
  def new
    @title = 'Sign Up'
    @profile = UserProfile.new
  end

  def create
  	#Make sure the 'login' field value corresponds to a UserProfile's or student's id_no
    user = UserProfile.find_by_id_no(params[:user_profile][:login])
    if user
      @profile = UserProfile.new(params[:user_profile])
      @profile.user=user
      @profile.branch=temp_branch
      if @profile.save
        flash[:notice] = "Signed up! Please login."
        redirect_to log_in_path
      else
        render :new
      end
    else
      flash[:error] =  "Unable to sign up. Please contact the admin to add your profile"
      redirect_to sign_up_path
    end
  end
  
  def update
  	# Here we are going to update only the roles for this user profile.
  	#None of the other fields of the user profiles are editable, for now.
  	#All the memberships corresponding to this user profile are deleted,
  	#and the new memberships are added. Yes, this is redundant! Performance
  	#needs to be tuned. TODO.
  	memberships = []
    @user_profile = UserProfile.find(params[:id])
    #NOTE: 
    #We cannot write -  old_memberships = @user_profile.role_memberships.
    #This seems to give a reference, not the absolute entries. If we do this.
    #after we build new memberships for this profile, the new ones also are
    #coming as a part of old_memberships. When we delete the old_memberships
    #the newly built ones will also get deleted, resulting in no roles for this profile.
	old_memberships = RoleMembership.for_user_profile(@user_profile.id)
    role_ids = params[:profile_roles] || []
    role_ids.each do |role_id|
      memberships << {:role_id => role_id}
    end
    @user_profile.role_memberships.build(memberships) 
    if @user_profile.role_memberships.all?(&:valid?) 
      if old_memberships
        old_memberships.each do |om|	
          om.destroy #--> This is the place I am referring above
        end
      end
      @user_profile.role_memberships.each(&:save!)
      flash[:notice] = "Roles successfully updated"
      redirect_to user_profile_path(@user_profile)
    else
      render :edit, :error => "Cannot updates roles to this user profile"
    end
  end

  def edit
  	@title = 'Edit User Profile'
    @user_profile = UserProfile.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end 
   end
    
  def show
    @user_profile = UserProfile.find(params[:id])
  end  
end
