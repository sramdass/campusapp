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

require 'spec_helper'

describe Branch do
  before do
  	Branch.delete_all
  	Faculty.delete_all
  	Subject.delete_all
  	Clazz.delete_all  	
  end	

  before(:each) do
    @attr = FactoryGirl.attributes_for(:branch)
    @branch = Branch.new
  end

  it "should create a new instance given valid attributes" do
    Branch.create!(@attr)
  end
  it "should require a name" do
    no_name_branch = Branch.new(@attr.merge(:name => ""))
    no_name_branch.should_not be_valid
  end
  it "should require a address" do
    no_address_branch = Branch.new(@attr.merge(:address => ""))
    no_address_branch.should_not be_valid
  end  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_branch = Branch.new(@attr.merge(:name => long_name))
    long_name_branch.should_not be_valid
  end
  it "should reject addresses that are too long" do
    long_address = "a" * 301
    long_address_branch = Branch.new(@attr.merge(:name => long_address))
    long_address_branch.should_not be_valid
  end
  
  #Associations
  it "should respond to faculties (association)" do
    @branch.should respond_to(:faculties)
  end  
  it "should respond to clazzzs (association)" do
    @branch.should respond_to(:clazzs)
  end  
  it "should respond to subjects (association)" do
    @branch.should respond_to(:subjects)
  end  
  it "should respond to resource_type (association)" do
    @branch.should respond_to(:resource_type)
  end       
  after do
  	Branch.delete_all
  	Faculty.delete_all
  	Subject.delete_all
  	Clazz.delete_all  	
  end   
end
