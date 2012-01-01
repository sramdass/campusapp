class SecStudentMap < ActiveRecord::Base
  belongs_to :section, :dependent => :destroy
  belongs_to :student, :dependent => :destroy	
  
  scope :for_student, lambda { |student_id| where('student_id = ? ', student_id)}             					    
  scope :for_section, lambda { |section_id| where('section_id = ? ', section_id)}             					    
end
