# == Schema Information
#
# Table name: details
#
#  id              :integer         not null, primary key
#  email           :string(255)
#  secondary_email :string(255)
#  phone           :string(255)
#  secondary_phone :string(255)
#  address         :string(255)
#  dob             :date
#  member_type     :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  blood_group_id  :integer
#  member_id       :integer
#

class Detail < ActiveRecord::Base
  belongs_to :member, :polymorphic => true
  #validates_presence_of :member

  belongs_to :blood_group
  
  validates 		:email,										:presence => true,   
            															:uniqueness => true,   
            															:format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }    
  
  validates 		:secondary_email,				:presence => true,   
            															:uniqueness => true,   
            															:format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }  
  validates 		:phone,									:presence => true,
																		:length => {:maximum => 13}
  validates 		:secondary_phone, 				:presence => true,
																		:length => {:maximum => 13}										
  validates 		:address,								:length => {:maximum => 500}
  validates    	:dob,										:presence => true
  validate 		:dob_should_not_be_in_the_past
  
  def dob_should_not_be_in_the_past
  	if dob && dob >= Date.today
  	  errors.add(:dob, "should not be later than current date")
  	end
  end
  
end
