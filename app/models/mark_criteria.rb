class MarkCriteria < BranchScopedModel
  belongs_to :section
  validates_presence_of :section
  belongs_to :exam
  validates_presence_of :exam
  belongs_to :subject
  validates_presence_of :subject
  
  validate :max_marks_should_not_be_less_than_any_individual_marks
  validate :max_marks_should_be_ge_to_pass_marks
  
  #Since we are changing the pass_marks here, that will affect the number of arrears for this section students
  after_save :update_arrears_for_this_section
  
  #Check if the individual marks corresponding to this subject is more than max_marks!
  def max_marks_should_not_be_less_than_any_individual_marks
    #This will get hsh[subject_id] = 'corresponding_mark_column' in the marks table
    hsh = mark_columns_with_subject_ids(self.section) 
    marks = Mark.for_section(self.section_id).for_exam(self.exam_id).all
    col_name = hsh[self.subject_id]
    marks.each do |mark|
      if mark.send(col_name) && (mark.send(col_name) > self.max_marks)
        errors.add(:max_marks, "should not be less than individual marks")
      end
    end
  end
  
  def update_arrears_for_this_section
    #This will get hsh[subject_id] = 'corresponding_mark_column' in the marks table
    hsh = mark_columns_with_subject_ids(self.section) 
    marks = Mark.for_section(self.section_id).for_exam(self.exam_id).all
    marks.each do |mark|
      arrears = 0	
      hsh.each do |sub_id, col_name|
        if mark.send(col_name) && (mark.send(col_name) < self.pass_marks)
          arrears = arrears + 1
        end
        mark.arrears = arrears
        mark.save!
      end
    end
  end
  
  def max_marks_should_be_ge_to_pass_marks  
  	if max_marks && pass_marks && (max_marks < pass_marks)
  	  errors.add(:max_marks, "should be greater than pass marks")
  	end
  end
  
  #This will return a hash with each of the subject id of the section as the key and the corresponding mark column as the value
  def mark_columns_with_subject_ids(section)
    h = Hash.new
    section.sec_sub_maps.each do |map|
      name =map.subject_id
      h[name] = map.mark_column
    end
    return h
  end	
    
end
