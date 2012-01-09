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

class SecExamMap < ActiveRecord::Base
  belongs_to :section, :dependent => :destroy
  belongs_to :exam, :dependent => :destroy
end
