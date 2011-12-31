module TestingMacros
	
  def delete_extra_resources
  	delete_extra_branches
  	delete_extra_faculties
  	delete_extra_subjects
  	delete_extra_clazzs
  	delete_extra_exams
  	delete_extra_students
  	delete_extra_user_profiles
  end
  	
  def delete_extra_branches
  	branches = Branch.find(:all, :conditions => ["name like ?", "%branch%"])
  	branches.each do |b|
  	  b.delete
  	end
  end
  
  def delete_extra_faculties
  	faculties = Faculty.find(:all, :conditions => ["name like ?", "%faculty%"])
  	faculties.each do |f|
  	  f.delete
  	end
  end
  
  def delete_extra_subjects
  	subjects = Subject.find(:all, :conditions => ["name like ?", "%subject%"])
  	subjects.each do |s|
  	  s.delete
  	end
  end
  
    def delete_extra_clazzs
  	clazzs = Clazz.find(:all, :conditions => ["name like ?", "%clazz%"])
  	clazzs.each do |c|
  	  c.delete
  	end
  end    
  
  def delete_extra_exams
  	
  end
  
  def delete_extra_students
  	
  end
  
  def delete_extra_user_profiles
  	users = UserProfile.find(:all, :conditions => ["login like ?", "%123%"])
  	users.each do |u|
  	  u.delete
  	end  	
  end
  
  def current_user
  	c = UserProfile.find_by_login("xxxx") || Factory(:current_user)
  end
  
end