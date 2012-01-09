class Mark < ActiveRecord::Base
  belongs_to :section
  belongs_to :student
  belongs_to :exam

  validates_presence_of :section
  validates_presence_of :student
  validates_presence_of :exam	

  before_save :update_total, :update_arrears
  
  scope :for_student, lambda { |student_id| where('student_id = ? ', student_id)}             					    
  scope :for_section, lambda { |section_id| where('section_id = ? ', section_id)}
  scope :for_exam, lambda { |exam_id| where('exam_id = ? ', exam_id)}      
  	
  def update_total
    total = 0
    hsh = mark_columns_with_subject_ids(self.section) 
    hsh.each do |sub_id, col_name|
      if self.send(col_name)
        total = total + self.send(col_name)
      end
    end
    self.total=total	
  end

  def update_arrears
   arrears = 0	
   #This will get hsh[subject_id] = 'corresponding_mark_column' in the marks table
   hsh = mark_columns_with_subject_ids(self.section) 
   hsh.each do |sub_id, col_name|
     pass_marks = self.section.sec_sub_maps.find_by_subject_id(sub_id).pass_marks
     if self.send(col_name) != nil
      if self.send(col_name) < pass_marks
        arrears = arrears + 1
      end
     end
   end
   self.arrears=arrears
   end

  def self.total_on(section_id, subject_id, exam_id)
   column_name = SecSubMap.by_section_id(section_id).by_subject_id(subject_id).first.mark_column
   where('section_id = ? and exam_id = ?', section_id, exam_id).sum(column_name.to_sym)
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
