class SecSubMap < ActiveRecord::Base
	belongs_to :section, :dependent => :destroy
	belongs_to :subject, :dependent => :destroy
	
	belongs_to :faculty	# no dependent destroy. When the faculty is removed we still want to know which subject goes to which section
	
	# If we give this we will always get "Faculty cannot be blank validation error." During the update and create the section along with its
	#sec_sub_maps and sec_exam_maps are saved before we parse the parameters and update the faculty_ids.
	#validates_presence_of :faculty
end
