# == Schema Information
#
# Table name: subjects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  branch_id  :integer
#  year_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Subject < BranchScopedModel
  belongs_to :year
  validates_presence_of :year
  
  belongs_to :branch
  
  has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
  has_many :subjects, :through => :sec_sub_maps  
  
  validates 	:name, 	:presence => true, 
               						:length => {:maximum => 30},
               						:uniqueness => true	
end
