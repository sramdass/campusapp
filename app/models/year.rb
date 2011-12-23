# == Schema Information
#
# Table name: years
#
#  id         :integer         not null, primary key
#  year       :string(255)
#  current    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Year < ActiveRecord::Base
end
