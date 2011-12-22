class Faculty < ActiveRecord::Base
  belongs_to :branch
  validates_presence_of :branch
  
  validates 	:name, 	:presence => true, 
                       				:length => {:maximum => 50}
  validates 	:id_no,	:presence => true, 
                       				:length => {:maximum => 20},
                       				:uniqueness => true
  validates 	:female, :inclusion => { :in => [true, false] }  
  validate :date_joined_should_be_less_than_date_departed
  
  def date_joined_should_be_less_than_date_departed
    if date_joined > date_departed
      errors.add(:date_departed, "should be later than date_joined")
    end
  end  
end
