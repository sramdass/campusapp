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
  
  after_destroy :destroy_marks
  
  scope :for_student, lambda { |student_id| where('student_id = ? ', student_id)}             					    
  scope :for_section, lambda { |section_id| where('section_id = ? ', section_id)}
  
  def destroy_marks
    destroy_marks = Marks.for_student(self.student_id).for_section(self.section_id).all
    destroy_marks.each do |dm|
      dm.destroy
    end
  end

end
