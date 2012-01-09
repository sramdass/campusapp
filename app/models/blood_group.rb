# == Schema Information
#
# Table name: blood_groups
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class BloodGroup < ActiveRecord::Base
  has_many :details
end
