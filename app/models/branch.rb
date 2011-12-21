# == Schema Information
#
# Table name: branches
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  address          :string(255)
#  resource_type_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Branch < ActiveRecord::Base
  belongs_to :resource_type
  validates_presence_of :resource_type
  
#-------VALIDATIONS------------#
  validates 	:name, 	:presence => true, 
               					    :length => {:maximum => 50}
  validates 	:address, 	:presence => true,                					
										:length => {:maximum => 300}
end
