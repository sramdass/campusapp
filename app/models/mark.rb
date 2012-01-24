class Mark < ActiveRecord::Base
  belongs_to :section
  belongs_to :student
  belongs_to :exam

  validates_presence_of :section
  validates_presence_of :student
  validates_presence_of :exam	
  
  validate :mark_should_not_be_greater_than_max_marks

  before_save :update_total, :update_arrears
  
  scope :for_student, lambda { |student_id| where('student_id = ? ', student_id)}             					    
  scope :for_section, lambda { |section_id| where('section_id = ? ', section_id)}
  scope :for_exam, lambda { |exam_id| where('exam_id = ? ', exam_id)}      
  	
  def update_total
    total = 0
    hsh = Mark.mark_columns_with_subject_ids(self.section) 
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
    hsh = Mark.mark_columns_with_subject_ids(self.section) 
    hsh.each do |sub_id, col_name|
      pass_marks = get_pass_marks(self.section_id, sub_id, self.exam_id)  
      if self.send(col_name) && pass_marks && (self.send(col_name) < pass_marks)
        arrears = arrears + 1
      end
    end
   self.arrears=arrears
   end

  def self.total_on(section_id, subject_id, exam_id)
   column_name = SecSubMap.by_section_id(section_id).by_subject_id(subject_id).first.mark_column
   where('section_id = ? and exam_id = ?', section_id, exam_id).sum(column_name.to_sym)
  end

  def mark_should_not_be_greater_than_max_marks  
    #This will get hsh[subject_id] = 'corresponding_mark_column' in the marks table
    hsh = Mark.mark_columns_with_subject_ids(self.section) 
    hsh.each do |sub_id, col_name|
      max_marks = get_max_marks(self.section_id, sub_id, self.exam_id)  
      if self.send(col_name) && max_marks && (self.send(col_name) > max_marks)
        errors.add(col_name.to_sym, "should not be greater than the max_marks")      	
      end
    end
  end

  #This will return a hash with each of the subject id of the section as the key and the corresponding mark column as the value
  def self.mark_columns_with_subject_ids(section)
    h = Hash.new
    section.sec_sub_maps.each do |map|
      name =map.subject_id
      h[name] = map.mark_column
    end
    return h
  end		
  
  def self.get_max_marks(section_id, subject_id, exam_id)
    m = MarkCriteria.find_by_section_id_and_subject_id_and_exam_id(section_id, subject_id, exam_id)
    return m.max_marks if m
    return nil
  end
  
  def self.get_pass_marks(section_id, subject_id, exam_id)
    m = MarkCriteria.find_by_section_id_and_subject_id_and_exam_id(section_id, subject_id, exam_id)
    return m.pass_marks if m
    return nil
  end  
  
  def get_percentage(subject_id)
  	hash = Mark.mark_columns_with_subject_ids(self.section)
  	return (self.send(hash[subject_id]) /Mark. get_max_marks(self.section_id, subject_id, self.exam_id))*100
  end
  
  #get_percentages: will return a hash with key as the subject_id and value as the percentages for that particular mark record.
  def get_percentages
  	percentages = {} 
  	hash = Mark.mark_columns_with_subject_ids(self.section)
  	hash.each do |sub_id, col_name|
  	  percentages[sub_id] = get_percentage(sub_id)
  	end
  	return percentages
  end
  
  def self.get_max_marks_total(section_id, subject_id)
  	total = 0
  	Section.find(section_id).sec_exam_maps.each do |semap|
  	  m = Mark.get_max_marks(section_id, subject_id, semap.exam_id)
  	  total = total + m if m
  	end
  	return total
  end
  
  def self.get_percentage_for_total(total, section_id, subject_id)
  	(total / Mark.get_max_marks_total(section_id, subject_id)) * 100
  end
  
  def self.get_style_class_for_total(total, section_id, subject_id)
  	p = Mark.get_percentage_for_total(total, section_id, subject_id)
	Mark.style_class(p)	
  end
  
  def get_style_class(subject_id)
  	p = get_percentage(subject_id)
	Mark.style_class(p)
  end
  
  def self.style_class(p)
  	if p > 90
  	  return 'bg-grade1'
  	elsif p > 80
  	  return 'bg-grade2'
  	elsif p > 70
  	  return 'bg-grade3'
  	elsif p > 60
  	  return 'bg-grade4'
  	elsif p > 50
  	  return 'bg-grade5'
  	elsif p > 40
  	  return 'bg-grade6'
  	elsif p > 30
  	  return 'bg-grade7'
  	end    	
  end
end
