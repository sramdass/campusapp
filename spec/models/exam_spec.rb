# == Schema Information
#
# Table name: exams
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  branch_id  :integer
#  year_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Exam do
  pending "add some examples to (or delete) #{__FILE__}"
end
