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

require 'spec_helper'

describe Faculty do

  before(:each) do
  	branch=Branch.first
  	if !branch
  		branch=Branch.create!(:name => "Jawahar", :address => "Neyveli-15", :resource_type_id => 2);
  	end
    @attr = { :name => "Jawahar", :id_no => "1234", :female => true, :date_joined => Date.today-5, :date_departed => Date.today-1, :branch_id => branch.id, :resource_type_id => 4 }
  end

  it "should create a new instance given valid attributes" do
    Faculty.create!(@attr)
  end
  it "should require a name" do
    no_name_faculty = Faculty.new(@attr.merge(:name => ""))
    no_name_faculty.should_not be_valid
  end
  it "should require a id_no" do
    no_id_no_faculty = Faculty.new(@attr.merge(:id_no => ""))
    no_id_no_faculty.should_not be_valid
  end  
  it "should have a valid value for gender" do
    #TODO: Make this work
  	#invalid_gender_faculty = Faculty.new(@attr.merge(:female => "123"))
    #invalid_gender_faculty.should_not be_valid
    no_gender_faculty = Faculty.new(@attr.merge(:female => nil))
    no_gender_faculty.should_not be_valid
  end
  it "should have valid date_joined and date_departed" do
    f = Faculty.new(@attr.merge(:date_joined => Date.today + 1))
    f.should_not be_valid
    f = Faculty.new(@attr.merge(:date_departed => Date.today + 1))
    f.should_not be_valid
    @attr1 = @attr.merge(:date_joined => Date.today-10)
    f = Faculty.new(@attr1.merge(:date_departed => Date.today-11))
    f.should_not be_valid
  end    
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_faculty = Faculty.new(@attr.merge(:name => long_name))
    long_name_faculty.should_not be_valid
  end
  it "should reject id_no  that are too long" do
    long_id_no = "a" * 21
    long_id_no_faculty = Faculty.new(@attr.merge(:id_no => long_id_no))
    long_id_no_faculty.should_not be_valid
  end
  
  #Associations
  it "should respond to branch (association)" do
    faculty = Faculty.new
    faculty.should respond_to(:branch)
  end  

end
