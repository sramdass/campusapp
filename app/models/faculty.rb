# == Schema Information
#
# Table name: faculties
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  female           :boolean
#  date_joined      :date
#  date_departed    :date
#  branch_id        :integer
#  resource_type_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  id_no            :string(255)
#

class Faculty < BranchScopedModel
  belongs_to :resource_type
  
  #These are the section to which this faculty is class teacher
  has_many :sections
  
  #These are the section + subject combination the faculty teaches
  has_many :sec_sub_maps
  
  has_one :user_profile, :as => :user, :dependent => :destroy
  has_one :detail, :as => :member, :dependent => :destroy
  accepts_nested_attributes_for :detail,  :reject_if => :has_only_destroy?, :allow_destroy => true  
  
  validates 	:name, 	:presence => true, 
                       				:length => {:maximum => 50}
  validates 	:id_no,	:presence => true, 
                       				:length => {:maximum => 20},
                       				:uniqueness => true
  validates 	:female, :inclusion => { :in => [true, false] }
  validate :date_joined_and_date_departed
  validate :resource_type_id_should_correspond_for_Faculty
  
  def date_joined_and_date_departed
  	if date_joined && date_joined > Date.today
  	  errors.add(:date_joined, "should not be later than current date")
  	end
  	if date_departed && date_departed > Date.today
  	  errors.add(:date_departed, "should not be later than current date")
  	end
    if date_joined && date_departed && (date_joined > date_departed)
      errors.add(:date_departed, "should be later than date_joined")
    end
  end
  
  def resource_type_id_should_correspond_for_Faculty
  	if resource_type_id
  	  res = Resource.find_by_name("Faculty")
  	  if ResourceType.where("id = ? and resource_id = ?", resource_type_id, res.id).empty?
         errors.add(:resource_type_id, "does not correspond to Faculty")  		
  	  end
  	end
  end	  
  
  def gender
  	if female?
  	  return "Female"
  	else
  	  return "Male"
  	end
  end
  
  def type
  	if self.resource_type
  		return self.resource_type.name
  	else
  		return "N/A"
  	end
  end
  
#Returns true if there is only "_destroy" attribute available for nested models.
  def has_only_destroy?(attrs)
    attrs.each do |k,v|
      if k !="_destroy" && !v.blank?
        return false
      end
      end
    return true	
  end	  
end
