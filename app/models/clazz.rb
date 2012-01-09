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
  
  validates 	:name, 	:presence => true, 
               						:length => {:maximum => 30},
               						:uniqueness => true
               						
  has_many :sections, :dependent => :destroy
  accepts_nested_attributes_for :sections, :reject_if => :has_only_destroy?, :allow_destroy => true      
  
  def has_only_destroy?(attrs)
    attrs.each do |k,v|
     if k !="_destroy" && !v.blank?
       return false
     end
    end
    return true	
  end		           						
end
