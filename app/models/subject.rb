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
  
  has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
  has_many :sections, :through => :sec_sub_maps  
  
  has_many :mark_criterias, :dependent => :destroy  #for pass_marks and max_marks  
  
  validates 	:name, 	:presence => true, 
               						:length => {:maximum => 30},
               						:uniqueness => true	
              						
end
