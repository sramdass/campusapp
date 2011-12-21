# == Schema Information
#
# Table name: resources
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Resource < ActiveRecord::Base
  has_many :resource_types
end
