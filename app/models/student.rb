class Student < ActiveRecord::Base
  belongs_to :branch
  belongs_to :resource_type
  
  has_one :user_profile, :as => :user
  
  has_many :sec_student_maps, :dependent => true, :dependent => :destroy
  has_many :sections, :through => :sec_student_maps  
  
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
end
