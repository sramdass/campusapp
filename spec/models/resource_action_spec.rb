# == Schema Information
#
# Table name: resource_actions
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  code        :integer
#  description :string(255)
#  resource_id :integer
#

require 'spec_helper'

describe ResourceAction do
  pending "add some examples to (or delete) #{__FILE__}"
end
