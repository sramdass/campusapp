# == Schema Information
#
# Table name: resource_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  resource_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class ResourceType < ActiveRecord::Base
  belongs_to :resource
  validates_presence_of :resource
  
  #Warning! Make sure to use dependent destroy, incase there are any has_many assoiciations here.
  
  validates 	:name, 	:presence => true, 
               					    :length => {:maximum => 50}    
end
