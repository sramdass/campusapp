class Grade < BranchScopedModel
  validates 	:name, 								:presence => true, 
               													:length => {:maximum => 30},
               													:uniqueness => true	
  validates 	:cut_off_percentage, 		:presence => true, 
               													:length => {:maximum => 100, :minimum => 0}
end
