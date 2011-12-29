Factory.define :branch do |b|
  b.sequence(:name) 			{ |n| "foo#{n}" }
  b.address              				"3rd block, Neyveli-15"
  b.resource_type_id     		{ResourceType.find_by_name("School").id }
end

Factory.define :branch_with_all, :parent => :branch do |branch|
  branch.after_create do |b|
    b.faculties = [Factory.create(:faculty, :branch_id => b.id)]
    b.subjects = [Factory.create(:subject, :branch_id => b.id)]
    b.clazzs = [Factory.create(:clazz, :branch_id => b.id)]
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
  	f.branch_id					{Branch.first.id}  #By default, assign this to the first branch. While creating a new branch. overwrite this value
  end

Factory.define :clazz do |c|
    c.sequence(:name) 			{|n| "clazz#{n}" }
    c.year_id							{Year.find_by_current(true)}
    c.branch_id						{Branch.first.id}
  end
  
Factory.define :subject do |s|
    s.sequence(:name) 		{|n| "subject#{n}" }
    s.year_id						{Year.find_by_current(true)}
    s.branch_id					{Branch.first.id}
  end  
