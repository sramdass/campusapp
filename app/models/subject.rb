class Subject < BranchScopedModel
  belongs_to :year
  validates_presence_of :year
  
  belongs_to :branch
  
  validates 	:name, 	:presence => true, 
               						:length => {:maximum => 30},
               						:uniqueness => true	
end
