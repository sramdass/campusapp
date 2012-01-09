# == Schema Information
#
# Table name: sec_student_maps
#
#  id         :integer         not null, primary key
#  student_id :integer
#  section_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class SecStudentMap < ActiveRecord::Base
  belongs_to :section, :dependent => :destroy
  belongs_to :student, :dependent => :destroy	
  
  scope :for_student, lambda { |student_id| where('student_id = ? ', student_id)}             					    
  scope :for_section, lambda { |section_id| where('section_id = ? ', section_id)}             					    
end
