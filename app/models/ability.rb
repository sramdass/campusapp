class Ability
  include CanCan::Ability

  def initialize(profile)
	@profile = profile
	@profile ||= Profile.new
	#can :read, Faculty, :id_no => profile.login
	@profile.roles.each do |role|
	  Resource.all.each do |res|
	    res.resource_actions.each do |ra|
	      if role.has_privilege?(res.id, ra.code)
	      	if ra.name.eql?("self_read_only")
	          can :read, Faculty, :id_no => @profile.login
            elsif ra.name.eql?("section_read_only")
              can :read, Faculty, {:id_no => faculties_from_same_section(@profile.login)}
            elsif ra.name.eql?("class_read_only")
              can :read, Faculty, :id_no => @profile.login
            end
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
  
  def faculties_from_same_section(id_no)
  	#Find the section ids for which this id_no (faculty) is the class teacher. Remember a faculty has_many sections he own.
  	debugger
  	same_section_ids = Faculty.find_by_id_no(id_no).sections.map {|sec| sec.id }
  	#Find the other faculties who takes other subjects for all the sections found above.
  	SecSubMap.where(:section_id => same_section_ids).all.map{|secsubmap| secsubmap.faculty.id_no}
  end
end
