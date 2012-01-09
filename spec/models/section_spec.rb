# == Schema Information
#
# Table name: sections
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  faculty_id :integer
#  clazz_id   :integer
#  branch_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Section do
  pending "add some examples to (or delete) #{__FILE__}"
end
