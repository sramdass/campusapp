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
  has_many :faculties, :dependent => :destroy
  accepts_nested_attributes_for :faculties, :reject_if => :has_only_destroy?, :allow_destroy => true
  
  has_many :students, :dependent => :destroy
  accepts_nested_attributes_for :students, :reject_if => :has_only_destroy?, :allow_destroy => true  
  
  has_many :clazzs, :dependent => :destroy
  accepts_nested_attributes_for :clazzs, :reject_if => :has_only_destroy?, :allow_destroy => true  
  
  has_many :subjects, :dependent => :destroy
  accepts_nested_attributes_for :subjects, :reject_if => :has_only_destroy?, :allow_destroy => true    
  
  has_many :exams, :dependent => :destroy
  accepts_nested_attributes_for :exams, :reject_if => :has_only_destroy?, :allow_destroy => true      
  
  has_many :roles, :dependent => :destroy
  accepts_nested_attributes_for :roles, :reject_if => :has_only_destroy?, :allow_destroy => true        
  
  belongs_to :resource_type
  validates_presence_of :resource_type
  
#-------VALIDATIONS------------#
  validates 	:name, 	:presence => true, 
               					    :length => {:maximum => 50}
  validates 	:address, 	:presence => true,                					
										:length => {:maximum => 300}
  validate :resource_type_id_should_correspond_for_Branch			
  
  class << self
    def current
      Thread.current[:current_tenant]
    end

    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end							


  def resource_type_id_should_correspond_for_Branch
  	res = Resource.find_by_name("Branch")
  	if res
  	  if ResourceType.where("id = ? and resource_id = ?", resource_type_id, res.id).empty?
         errors.add(:resource_type_id, "does not correspond to Branch")
  	  end
  	else
  		errors.add(:resource_type_id, ' - cannot find the resource type "Branch"')  		
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
