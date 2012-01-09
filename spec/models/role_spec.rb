# == Schema Information
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  branch_id   :integer
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Role do
  pending "add some examples to (or delete) #{__FILE__}"
end
