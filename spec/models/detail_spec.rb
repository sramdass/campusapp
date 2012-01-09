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

require 'spec_helper'

describe Detail do
  pending "add some examples to (or delete) #{__FILE__}"
end
