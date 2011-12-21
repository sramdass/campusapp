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
  pending "add some examples to (or delete) #{__FILE__}"
end
