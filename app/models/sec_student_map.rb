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
  belongs_to :section
  belongs_to :student
  
  #Whenever a student is removed from the section. make sure that the corresponding mark rows are deleted.
  #This can be done at different places, but each of them have some problems.
  #For example, this can be done when you build the marks table in the sections_controller. But, the marks table
  #is built only when the sections_controlller is invoked. 
  #For now, this seems to be the best place.
  after_destroy :destroy_marks
  
  scope :for_student, lambda { |student_id| where('student_id = ? ', student_id)}             					    
  scope :for_section, lambda { |section_id| where('section_id = ? ', section_id)}
  
  def destroy_marks
    destroy_marks = Mark.for_student(self.student_id).for_section(self.section_id).all
    destroy_marks.each do |dm|
      dm.destroy
    end
  end

end
