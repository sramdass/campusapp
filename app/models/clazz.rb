# == Schema Information
#
# Table name: clazzs
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  branch_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  year_id    :integer
#

class Clazz < BranchScopedModel
  belongs_to :year
  validates_presence_of :year
  
  belongs_to :branch
  
  validates 	:name, 	:presence => true, 
               						:length => {:maximum => 30},
               						:uniqueness => true
end
