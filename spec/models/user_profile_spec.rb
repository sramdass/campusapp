# == Schema Information
#
# Table name: user_profiles
#
#  id                     :integer         not null, primary key
#  login                  :string(255)
#  password_hash          :string(255)
#  password_salt          :string(255)
#  password_reset_token   :string(255)
#  auth_token             :string(255)
#  password_reset_sent_at :datetime
#  user_type              :string(255)
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  branch_id              :integer
#

require 'spec_helper'

describe UserProfile do
  before(:all) do
  	delete_extra_resources
  end
  before(:each) do
  	@branch = Factory(:branch)
    @attr = FactoryGirl.attributes_for(:user_profile).merge(:branch_id => @branch.id)
  end

  it "should create a new instance given valid attributes" do
    UserProfile.create!(@attr)
  end
  
  describe "password validations" do
    it "should require a password" do
      UserProfile.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    it "should require a matching password confirmation" do
      UserProfile.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      UserProfile.new(hash).should_not be_valid
    end
    it "should reject long passwords" do
      long = "a" * 51
      hash = @attr.merge(:password => long, :password_confirmation => long)
      UserProfile.new(hash).should_not be_valid
    end
  end #end of  describe "password validations" do
  

  describe "password encryption" do

    before(:each) do
      @up = Factory(:faculty_user)
    end
    it "should set the encrypted password" do
      @up.password_salt.should_not be_blank
      @up.password_hash.should_not be_blank
      @up.auth_token.should_not be_blank
    end
  end  
  
end
