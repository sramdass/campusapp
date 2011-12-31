class Exam < BranchScopedModel
  belongs_to :year
  validates_presence_of :year
  
  belongs_to :branch
  
  has_many :sec_exam_maps, :dependent => true, :dependent => :destroy
  has_many :exams, :through => :sec_exam_maps    
  
  validates 	:name, 	:presence => true, 
               						:length => {:maximum => 30},
               						:uniqueness => true		
end
