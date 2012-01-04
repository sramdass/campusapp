class ResourceAction < ActiveRecord::Base
  #  Refer the reason before the module definition
  #before_validation :update_action_code
  
  validates 	:name, 	:presence => true, 
  									:uniqueness => true,
               					    :length => {:maximum => 50}    
               					    
  validates 	:code,	 	:presence => true, 
  									:uniqueness => true,
  									:numericality => {:less_than => 32, :greater_than => -1}
               					    
  validates 	:name, 	:presence => true, 
               					    :length => {:maximum => 300}  

#This module was originally written to update the code automatically when the resource actions were created.
#But this poses a large problem. When a particular privilege(which is dependent on these code values) is stored 
#in the permissions table, these code are not supposed to change. The change will modify all the permission settings.
=begin
  def update_action_code
    actions = ResourceAction.order("code ASC")
    if actions.empty? 
      self.code = 0
      return
    end
    self.code = -1 #will fail at validation.
    start = 0
    allowed_code_values = 31
    actions.each do |a|
      if a.code != start && start <= allowed_code_values
      	self.code = start
      	return
      end
      start = start + 1
    end
    self.code = start if start <= allowed_code_values #Reached the end. No intermediate codes are available
  end
=end  
  
  end
