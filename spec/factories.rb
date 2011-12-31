Factory.define :branch do |b|
  b.sequence(:name) 			{ |n| "branch#{n}" }
  b.address              				"3rd block, Neyveli-15"
  b.resource_type_id     		{ResourceType.find_by_name("School").id }
end

Factory.define :branch_with_all, :parent => :branch do |branch|
  branch.after_create do |b|
    b.faculties = [Factory.create(:faculty, :branch => b)]
    b.subjects = [Factory.create(:subject, :branch => b)]
    b.clazzs = [Factory.create(:clazz, :branch_id => b)]
  end
end

Factory.define :branch_with_faculties, :parent => :branch do |branch|
  branch.after_create do |b|
    b.faculties = [Factory.create(:faculty, :branch_id => b.id)]
  end
end

Factory.define :branch_with_subjects, :parent => :branch do |branch|
  branch.after_create do |b|
    b.subjects = [Factory.create(:subject, :branch_id => b.id)]
  end
end

Factory.define :branch_with_clazzs, :parent => :branch do |branch|
  branch.after_create do |b|
    b.clazzs = [Factory.create(:clazz, :branch_id => b.id)]
  end
end

Factory.define :faculty do |f|
  	f.sequence(:name) 		{|n| "faculty#{n}" }
    f.sequence(:id_no) 		{|n| "123#{n}"}
  	f.female							false
  	f.date_joined					{Date.today-5}
  	f.date_departed			{Date.today-3}
  	f.resource_type_id		{ResourceType.find_by_name("Teaching").id }
  	f.association(:branch) #The branch_id has to be overwritten when this faculty is created in the after_save of a branch.
end

Factory.define :clazz do |c|
    c.sequence(:name) 			{|n| "clazz#{n}" }
    c.year_id							{Year.find_by_current(true)}
    c.association(:branch) #The branch_id has to be overwritten when this clazz is created in the after_save of a branch.
end
  
Factory.define :subject do |s|
    s.sequence(:name) 		{|n| "subject#{n}" }
    s.year_id						{Year.find_by_current(true)}
    s.association(:branch) #The branch_id has to be overwritten when this subject is created in the after_save of a branch.
end

Factory.define :user_profile do |up|
  up.sequence(:login)                 	{|n| "123#{n}"}
  up.password             				 	{ "password"   }
  up.password_confirmation 		{ |u| u.password  }
  up.association(:branch)
end

Factory.define :faculty_user, :parent => :user_profile do |up|
  up.user {|u| u.association(:faculty)}
  up.after_create do |u|
    u.login = u.user.id_no
    Branch.find(u.branch_id).delete
    u.branch_id = u.user.branch_id
  end	
end

Factory.define :current_user, :class => :user_profile do |cu|
  cu.branch_id			{Branch.find_by_name("Jawahar").id} 
  cu.user 					{|u| u.association(:faculty, 
  																	:name => "current_faculty_user", 
  																	:id_no => "xxxx",
  																	:branch => Branch.find_by_name("Jawahar"))}
  cu.login					{|u| u.user.id_no}  
  cu.password             				 	{ "password"   }
  cu.password_confirmation 		{ |u| u.password  }  			
end


