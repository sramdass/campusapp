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

class SecSubMap < BranchScopedModel
  belongs_to :section, :dependent => :destroy
  belongs_to :subject, :dependent => :destroy
  
  # no dependent destroy. When the faculty is removed we still want to know which subject goes to which section	
  belongs_to :faculty	
  
  # If we give this we will always get "Faculty cannot be blank validation error." During the update and create the section along with its
  #sec_sub_maps and sec_exam_maps are saved before we parse the parameters and update the faculty_ids.
  #validates_presence_of :faculty
  
  validate :mark_column_should_in_valid_range
  
  def mark_column_should_in_valid_range
  	if !mark_column
      errors.add(:mark_column, "should not be blank")
  	end
  	col_nos = (1..MARKS_SUBJECTS_COUNT).to_a
  	mark_cols = col_nos.map {|col_no| "sub#{col_no}"}
  	if !mark_cols.include?(mark_column)
  	  errors.add(:mark_column, "is not valid")
  	end
  end
end
