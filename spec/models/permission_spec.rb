# == Schema Information
#
# Table name: permissions
#
#  id          :integer         not null, primary key
#  role_id     :integer
#  resource_id :integer
#  privilege   :integer
#  constraints :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Permission do
  pending "add some examples to (or delete) #{__FILE__}"
end
