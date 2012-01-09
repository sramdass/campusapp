# == Schema Information
#
# Table name: sections
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  faculty_id :integer
#  clazz_id   :integer
#  branch_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Section < BranchScopedModel
  #This is the class teacher
  belongs_to :faculty
  
  belongs_to :clazz
  validates_presence_of :clazz	
  
  has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
  has_many :subjects, :through => :sec_sub_maps
  
  has_many :sec_exam_maps, :dependent => true, :dependent => :destroy
  has_many :exams, :through => :sec_exam_maps  
  
  has_many :sec_student_maps, :dependent => true, :dependent => :destroy
  has_many :students, :through => :sec_student_maps  
  
  validates 	:name, 	:presence => true, 
               					    :length => {:maximum => 50}
               					    
  scope :from_branch, lambda { |branch_id| joins(:clazz).where('clazzs.branch_id = ? ', branch_id)}             					    

end
