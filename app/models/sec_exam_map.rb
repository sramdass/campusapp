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

class SecExamMap < BranchScopedModel
  belongs_to :section
  validates_presence_of :section
  belongs_to :exam
  validates_presence_of :exam
end
