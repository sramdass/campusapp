class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_profile, :current_year, :current_year_id
  helper_method :temp_branch  #This has to be removed once the multitenant architecture is in place
  before_filter :mailer_set_url_options  
  before_filter :set_tenant_branch
  #before_filter { |c| Authorization.current_user = c.current_profile }  
  
  rescue_from CanCan::AccessDenied do |exception|
   if current_profile
     redirect_to dashboard_path, :alert => "You are not allowed to access that page"
   #Use this here: - request.env['HTTP_REFERER'] || root_url
   else
     redirect_to log_in_path, :alert => "Please log in/sign up before accessing the application"
   end
  end  
  
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
  
  def current_year
  	Year.find_by_current(true)
  end
  
  def current_year_id
  	current_year.id
  end

  def hash_to_keys_array(hsh)
    keys = Array.new
    hsh.each do |k, v|
      keys << k
    end
    return keys		
  end

  def hash_to_values_array(hsh)
    values = Array.new
    hsh.each do |k, v|
      values << v
    end
    return values
  end

  #This will return the ability of the current_profile
  def current_ability
    @current_ability ||= Ability.new(current_profile)
  end	

  #Returns the ability of the 'profile'. 
  #Refer 'D:\myapps\white_reports\annotate\ruby\1.8\gems\cancan-1.6.5\lib\cancan\controller_additions.rb:381'
  def other_ability(profile)
    #This has to be re-initialized every time, as the profile can change
    @other_ability = Ability.new(profile)
  end		  
end
