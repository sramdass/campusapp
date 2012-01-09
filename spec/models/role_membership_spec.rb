# == Schema Information
#
# Table name: role_memberships
#
#  id              :integer         not null, primary key
#  role_id         :integer
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe RoleMembership do
  pending "add some examples to (or delete) #{__FILE__}"
end
