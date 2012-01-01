class Section < ActiveRecord::Base
  belongs_to :faculty
  
  belongs_to :clazz
  validates_presence_of :clazz	
  
  has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
  has_many :subjects, :through => :sec_sub_maps
  
  has_many :sec_exam_maps, :dependent => true, :dependent => :destroy
  has_many :exams, :through => :sec_exam_maps  
  
  validates 	:name, 	:presence => true, 
               					    :length => {:maximum => 50}
               					    
  scope :from_branch, lambda { |branch_id| joins(:clazz).where('clazzs.branch_id = ? ', branch_id)}             					    

end