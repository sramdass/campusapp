# == Schema Information
#
# Table name: students
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  id_no            :string(255)
#  female           :boolean
#  date_joined      :date
#  date_departed    :date
#  branch_id        :integer
#  resource_type_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Student < BranchScopedModel
  belongs_to :resource_type
  
  has_one :user_profile, :as => :user, :dependent => :destroy

  has_one :detail, :as => :member, :dependent => :destroy
  accepts_nested_attributes_for :detail,  :reject_if => :has_only_destroy?, :allow_destroy => true    
  
  has_many :sec_student_maps, :dependent => true, :dependent => :destroy
  has_many :sections, :through => :sec_student_maps  
  
  has_many :marks, :dependent => :destroy
  accepts_nested_attributes_for :marks, :reject_if => :has_only_destroy?, :allow_destroy => true
  
  validates 	:name, 	:presence => true, 
                       				:length => {:maximum => 50}
  validates 	:id_no,	:presence => true, 
                       				:length => {:maximum => 20},
                       				:uniqueness => true
  validates 	:female, :inclusion => { :in => [true, false] }
  validate :date_joined_and_date_departed
  validate :resource_type_id_should_correspond_for_Student
  
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
  
  def resource_type_id_should_correspond_for_Student
  	if resource_type_id
  	  res = Resource.find_by_name("Student")
  	  if ResourceType.where("id = ? and resource_id = ?", resource_type_id, res.id).empty?
         errors.add(:resource_type_id, "does not correspond to Student")  		
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
