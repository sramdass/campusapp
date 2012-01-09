# == Schema Information
#
# Table name: sec_sub_maps
#
#  id          :integer         not null, primary key
#  section_id  :integer
#  subject_id  :integer
#  faculty_id  :integer
#  mark_column :string(255)
#  branch_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe SecSubMaps do
  pending "add some examples to (or delete) #{__FILE__}"
end
