# == Schema Information
#
# Table name: sec_exam_maps
#
#  id         :integer         not null, primary key
#  section_id :integer
#  exam_id    :integer
#  startdate  :date
#  enddate    :date
#  branch_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe SecTestMaps do
  pending "add some examples to (or delete) #{__FILE__}"
end
