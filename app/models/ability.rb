class Ability
  include CanCan::Ability

  def initialize(profile)
	@profile = profile
	#Without a valid profile, no one can read anything.
	if !@profile
	  return
	end
	@user_type = @profile.user_type
	#All the aliases come here
	#All the create, update and destroy actions should have read permissions. Include them in the aliases itself
	alias_action :new, :read, :to => :create
	alias_action :edit, :read,:to => :update
	@profile.roles.each do |role|
	  Resource.all.each do |res|
	    res.resource_actions.each do |ra|
	      if role.has_privilege?(res.id, ra.code)
	        send("#{res.name.downcase}_#{ra.name}") # This will be like --> faculty_section_read
          end
	    end
	  end
		
	end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
  
  #--------------------helper modules---------------------------#
  def faculties_from_same_section(id_no)
  	#Find the section ids for which this id_no (faculty) is the class teacher. Remember a faculty has_many sections he own.
  	same_section_ids = Faculty.find_by_id_no(id_no).sections.map {|sec| sec.id }
  	#Find the other faculties who takes other subjects for all the sections found above.
  	SecSubMap.where(:section_id => same_section_ids).all.map{|secsubmap| secsubmap.faculty.id_no}
  end
  
  def faculties_from_same_section(id_no)
  	faculty = Faculty.find_by_id_no(id_no)
  	#Find the section ids for which this id_no (faculty) is the class teacher. Remember a faculty has_many sections he own.
  	class_teacher_for_sections = faculty.sections.map {|sec| sec.id } || []
  	teaches_sections = faculty.sec_sub_maps.map{|ssmap| ssmap.section_id} || []
  	total_sections = class_teacher_for_sections + teaches_sections
  	
  	#Find the other faculties who takes other subjects for all the sections found above.
  	SecSubMap.where(:section_id => total_sections).all.map{|secsubmap| secsubmap.faculty.id_no}
  end
  
  def class_teacher_for_section_ids(id_no)
  	#Find the section ids for which this id_no (faculty) is the class teacher. Remember a faculty has_many sections he own.
  	faculty = Faculty.find_by_id_no(id_no)
  	faculty.sections.map {|sec| sec.id } || []  	
  end
  
  def teaches_section_ids(id_no)
  	faculty = Faculty.find_by_id_no(id_no)
  	faculty.sec_sub_maps.map{|ssmap| ssmap.section_id} || []
  end
  
  #This will retun the list of clazz ids that have atlease one section for which the current user (profile) is a class teacher
  def class_teacher_for_clazz_ids(id_no)
    faculty = Faculty.find_by_id_no(id_no)
  	faculty.sections.map {|sec| sec.clazz.id } || []  	
  end
  
  #This will retun the list of clazz ids that have alteast one section that current user(profile) teaches  
  def teaches_clazz_ids(id_no)
    faculty = Faculty.find_by_id_no(id_no)
    faculty.sec_sub_maps.map{|ssmap| ssmap.section.clazz.id} || []  	
  end
  #--------------------end - helper modules---------------------------#
  
  #-----------------------------------------------------------------#
  # For each of the actions that a role can perform, one of the following methods will
  #be called. Ex: If the role is given permission to run the section_read resource action
  #for Faculty resource, then 'faculty_section_read' will get executed and the permissions
  #are given accordingly.
  
  #BRANCH
  
  def branch_read
    can :read, Branch
  end
  
  def branch_edit
    can :edit, Branch  	
  end
  
  def branch_create
    can :create, Branch  	
  end
  
  def branch_destroy
    can :destroy, Branch  	
  end
  
  #FACULTY
  def faculty_self_read
    can :read, Faculty, :id_no => @profile.login
  end
  
  def faculty_section_read
    can :read, Faculty, {:id_no => faculties_from_same_section(@profile.login)}
  end
  
  def faculty_class_read
  	faculty_section_read
    #This needs to be modified. As of now it is same as the section's 	
  end
  
  def faculty_all_read
    can :read, Faculty
  end
  
  def faculty_self_edit
    can :update, Faculty, :id_no => @profile.login
  end
  
  def faculty_section_edit
    can :update, Faculty, {:id_no => faculties_from_same_section(@profile.login)}
  end
  
  def faculty_class_edit
  	faculty_section_edit
    #This needs to be modified. As of now it is same as the section's 	
  end
  
  def faculty_all_edit
    can :update, Faculty
  end  
  
  def faculty_create
    can :create, Faculty
  end
  
  def faculty_bulk_op
    can [:facultynew, :facultycreate], Branch
  end
  
  def faculty_all_op
  	faculty_bulk_op # Since this is a part of the branches controller, specify this.
  	can :manage, Faculty
  end
  
  #CLAZZ
  
  def clazz_self_read
  	if @user_type.eql?("Faculty")
  	  can :read, Clazz do |clz|
  	    (class_teacher_for_clazz_ids(@profile.login) + teaches_clazz_ids(@profile.login)).include?(clz.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end
  end
  
  def clazz_all_read
    can :read, Clazz
  end
  
  def clazz_self_edit
  	if @user_type.eql?("Faculty")
  	  can :edit, Clazz do |clz|
  	    (class_teacher_for_clazz_ids(@profile.login) + teaches_clazz_ids(@profile.login)).include?(clz.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end  	
  end
  
  def clazz_all_edit
  	can :edit, Clazz
  end
  
  def clazz_create
  	can :create, Clazz
  end
  
  def clazz_self_destroy
  	if @user_type.eql?("Faculty")
  	  can :destroy, Clazz do |clz|
  	    (class_teacher_for_clazz_ids(@profile.login) + teaches_clazz_ids(@profile.login)).include?(clz.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end  	  	
  end
  
  def clazz_all_destroy
  	can :destroy, Clazz
  end   
  
  def clazz_bulk_op
    can [:clazznew, :clazzcreate]	, Branch
  end
  	
  def all_op
  	clazz_bulk_op
    can :manage, Clazz
  end  
  
  #SECTION
  
  def section_self_read
  	if @user_type.eql?("Faculty")
  	  can :read, Section do |sec|
  	    (class_teacher_for_section_ids(@profile.login) + teaches_section_ids(@profile.login)).include?(sec.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end
  end
  
  def section_class_read
  	if @user_type.eql?("Faculty")  	
  	  can :read, Section do |sec|
  	    (class_teacher_for_clazz_ids(@profile.login) + teaches_clazz_ids(@profile.login)).include?(sec.clazz.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end  	  
  end
  
  def section_all_read
    can :read, Section
  end
  
  def section_self_edit
  	if @user_type.eql?("Faculty")
  	  can :edit, Section do |sec|
  	    (class_teacher_for_section_ids(@profile.login) + teaches_section_ids(@profile.login)).include?(sec.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end  	
  end
  
  def section_class_edit
  	if @user_type.eql?("Faculty")  	
  	  can :edit, Section do |sec|
  	    (class_teacher_for_clazz_ids(@profile.login) + teaches_clazz_ids(@profile.login)).include?(sec.clazz.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end  	  	
  end
  
  def section_all_edit
  	can :edit, Section
  end
  
  def section_create
  	can :create, Section
  end
  
  def section_self_destroy
  	if @user_type.eql?("Faculty")
  	  can :destroy, Section do |sec|
  	    (class_teacher_for_section_ids(@profile.login) + teaches_section_ids(@profile.login)).include?(sec.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end  	  	
  end
  
  def section_class_destroy
  	if @user_type.eql?("Faculty")  	
  	  can :destroy, Section do |sec|
  	    (class_teacher_for_clazz_ids(@profile.login) + teaches_clazz_ids(@profile.login)).include?(sec.clazz.id)
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end  	  	
  end
  
  def section_all_destroy
  	can :destroy, Section
  end 
  
  def section_self_assign_students
    if @user_type.eql?("Faculty")  	
  	  can :assign_students, Section do |sec|
        (class_teacher_for_clazz_ids(@profile.login) + teaches_clazz_ids(@profile.login)).include?(sec.clazz.id)  		
  	  end
  	elsif @user_type.eql?("Student")
  		
  	end
  end

  def section_all_assign_students
  	can :assign_students, Section
  end  
  
  def section_bulk_op
    can [:sectionnew, :sectioncreate], Clazz
  end  
  
  def all_op
  	section_all_assign_students
    can :manage, Section
  end
  
  #ROLE
  
  def role_self_read
  	
  end
  
  def role_all_read
  	
  end  

  def role_self_edit
  	
  end

  def role_all_edit
  	
  end
    
  def role_create
  	
  end
  
  def role_destroy
  	
  end
  
  #USER_PROFILE
  
  def userprofile_self_read
  	
  end  
  
  def userprofile_all_read
  	
  end  
  
  def userprofile_self_edit
  	
  end  
  
  def userprofile_all_edit
  	
  end
  
  def userprofile_destroy
  	
  end  
  
end
