# == Schema Information
#
# Table name: students
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  id_no            :string(255)
#  female           :boolean
#  date_joined      :date
#  date_departed    :date
#  branch_id        :integer
#  resource_type_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Student do
  pending "add some examples to (or delete) #{__FILE__}"
end
