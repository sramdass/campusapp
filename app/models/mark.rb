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
  	
  #before filters
  #---------------------------------------------------------------------------#
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
  
   #Validations
  #---------------------------------------------------------------------------#
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
  
  #Helper Module
  #---------------------------------------------------------------------------#
  #This will return a hash with each of the subject id of the section as the key and the corresponding mark column as the value
  def self.mark_columns_with_subject_ids(section)
    h = Hash.new
    section.sec_sub_maps.each do |map|
      name =map.subject_id
      h[name] = map.mark_column
    end
    return h
  end	

  #CLASS Modules
  #---------------------------------------------------------------------------#
  # To find the total of all the student marks for  a section + exam + subject combo.
  def self.total_on(section_id, subject_id, exam_id)
   column_name = SecSubMap.by_section_id(section_id).by_subject_id(subject_id).first.mark_column
   where('section_id = ? and exam_id = ?', section_id, exam_id).sum(column_name.to_sym)
  end
  
  #Returns the max marks for a section + exam + subject combo.
  def self.get_max_marks(section_id, subject_id, exam_id)
    m = MarkCriteria.find_by_section_id_and_subject_id_and_exam_id(section_id, subject_id, exam_id)
    return m.max_marks if m
    return nil
  end
  
  #Returns the pass marks for a section + exam + subject combo.
  def self.get_pass_marks(section_id, subject_id, exam_id)
    m = MarkCriteria.find_by_section_id_and_subject_id_and_exam_id(section_id, subject_id, exam_id)
    return m.pass_marks if m
    return nil
  end  

  #Returns the total of all the exam marks corresponding to a particular subject in a section
  def self.get_subject_max_marks_total(section_id, subject_id)
  	total = 0
  	Section.find(section_id).sec_exam_maps.each do |semap|
  	  m = Mark.get_max_marks(section_id, subject_id, semap.exam_id)
  	  total = total + m if m
  	end
  	return total
  end
  
  #Returns the total of all the subject marks corresponding to a particular exam in a section
  def self.get_exam_max_marks_total(section_id, exam_id)
  	hash = Mark.mark_columns_with_subject_ids(Section.find(section_id))
  	total = 0
  	Section.find(section_id).sec_sub_maps.each do |ssmap|
  	  m = Mark.get_max_marks(section_id, ssmap.subject_id, exam_id)
  	  total = total + m if m
  	end
  	return total  	
  end
  
  #Returns the (total of subject_id's marks on all the exams) / (total of max marks of the same subject_id's) *100
  def self.get_percentage_for_subject_total(total, section_id, subject_id)
  	(total / Mark.get_subject_max_marks_total(section_id, subject_id)) * 100
  end
  
  #Returns the style class for a particular subjects' total.  The percentage value is calculated first
  #to determine the style class
  def self.get_subject_total_css_style(total, section_id, subject_id)
  	p = Mark.get_percentage_for_subject_total(total, section_id, subject_id)
  	g= Mark.get_grade(p)
	Mark.get_grade_css_style(g)	
  end
  
  #Returns the total of a students marks in different exams for a particular subject.
  #We cannot find the particular section from the student_id since a student has
  #many sections. So, we need the section_id here.
  def self.student_total_subject_marks(student_id, section_id, subject_id) 
  	total = 0 
  	hash = Mark.mark_columns_with_subject_ids(Section.find(section_id))
  	Mark.for_student(student_id).for_section(section_id).sum(hash[subject_id].to_sym)
  end
  
  #Return an hash that will have student_id as the key and the total (of the subject 'subject_id')
  #of all the exams. The hash will have information for all the students in this particular section.
  def self.students_total_subject_marks(section_id, subject_id)
  	hash = {}
  	Section.find(section_id).students.each do |student|
  	  hash[student.id] = Mark.student_total_subject_marks(student.id, section_id, subject_id)
  	end
  	return hash
  end
  
  #Returns the total of a students marks in different subjects  for a particular exam
  #We cannot find the particular section from the student_id since a student has
  #many sections. So, we need the section_id here.
  def self.student_total_exam_marks(student_id, section_id, exam_id) 
  	total = 0 
  	hash = Mark.mark_columns_with_subject_ids(Section.find(section_id))
  	mark = Mark.for_student(student_id).for_section(section_id).for_exam(exam_id)
  	hash.each do |sub_id, mark_col |
  		total = total + mark.send(hash[mark_col]) if mark.send(hash[mark_col])
  	end
  	return total
  end
  
  #Return an hash that will have student_id as the key and the total (of the exam 'exam_id')
  #of all the exams. The hash will have information for all the students in this particular section.
  def self.students_total_exam_marks(section_id, exam_id)
  	hash = {}
  	Section.find(section_id).students.each do |student|
  	  hash[student.id] = Mark.student_total_exam_marks(student.id, section_id, exam_id)
  	end
  	return hash
  end  
  
  def self.get_student_subject_marks_in_grade_order(section_id, subject_id, exam_id)
  	grade_order={}
  	hash = Mark.mark_columns_with_subject_ids(Section.find(section_id))
  	grades = Grade.order('cut_off_percentage DESC')
  	subject_marks = Mark.for_section(section_id).for_exam(exam_id).order("#{hash[subject_id]} DESC ")
  	max_p = (100 / Mark.get_max_marks(section_id, subject_id, exam_id))
  	grades.each do |grade|
  	  grade_order[grade.id] = subject_marks.select{|m| m.send(hash[subject_id])*max_p >= grade.cut_off_percentage}
  	  subject_marks.delete_if{|m| m.send(hash[subject_id]) >= grade.cut_off_percentage}
  	end
  end
  
  #Module to find the total of all exam marks for a section in a particular subject and the corresponding grades for each of the total
  #Return the hash with
  # key -> grade id
  # value -> Array of sub arrays. Each of the sub array will have two elements. the first element is the 
  #student_id, and the second element is the total marks of all the exams of the given subject (subject_id)
    def self.get_student_total_subject_marks_in_grade_order(section_id, subject_id)
  	hash = Mark.mark_columns_with_subject_ids(Section.find(section_id))
  	total_subject_marks = {}
    total_subject_marks = Mark.students_total_subject_marks(section_id, subject_id)
  	#Sort the student total marks in descending order. Note that I have used reverse! method to change the sort order
  	#Sort by will return an array of arrays of length 2. Each of the sub array  will have the key as the first element and 
  	#value as the second element
  	# total = {:a=>1, :b=>3, :c=>2}
  	# total.sort_by{|k,v| v} = [[:a, 1], [:c, 2], [:b, 3]]
  	total_subject_marks.sort_by{|stu_id, total| total}.reverse!
  	max_p = 100 / get_subject_max_marks_total(section_id, subject_id)
  	
  	grade_order={}
  	grades = Grade.order('cut_off_percentage DESC')
  	grades.each do |grade|
  	  grade_order[grade.id] = total_subject_marks.select{|m| (m[1]*max_p) >= grade.cut_off_percentage}
  	 total_subject_marks.delete{|m| m[1] >= grade.cut_off_percentage}
  	end
  	return grade_order
  end  
  
  #Module to find the total of all subject marks for a section in a particular exam
  #Return the hash with
  # key -> grade id
  # value -> Array of sub arrays. Each of the sub array will have two elements. the first element is the 
  #student_id, and the second element is the total marks of all the subjects of the given exam (exam_id)
  def self.get_student_total_exam_marks_in_grade_order(section_id, exam_id)
  	hash = Mark.mark_columns_with_subject_ids(Section.find(section_id))
  	total_exam_marks = {}
    total_exam_marks = Mark.students_total_exam_marks(section_id, exam_id)
  	#Sort the student total marks in descending order. Note that I have used reverse! method to change the sort order
  	#Sort by will return an array of arrays of length 2. Each of the sub array  will have the key as the first element and 
  	#value as the second element
  	# total = {:a=>1, :b=>3, :c=>2}
  	# total.sort_by{|k,v| v} = [[:a, 1], [:c, 2], [:b, 3]]
  	total_exam_marks.sort_by{|stu_id, total| total}.reverse!
  	max_p = 100 / get_exam_max_marks_total(section_id, exam_id)
  	grade_order={}
  	grades = Grade.order('cut_off_percentage DESC')
  	grades.each do |grade|
  	  grade_order[grade.id] = total_exam_marks.select{|m| m[1] >= grade.cut_off_percentage}
  	  total_exam_marks.delete{|m| (m[1]*max_p) >= grade.cut_off_percentage}
  	end
  	return grade_order
  end    
  
  #Returns the css style for a particular grade
  def self.get_grade_css_style(grade)
  	return "grade-#{grade.name}" if grade
  	return ""
  end

  #Returns the grade object for a particular percentage value.  
  def self.get_grade(percentage)
  	grades = Grade.order('cut_off_percentage DESC')
  	grades.each do |grade|
  	  return grade if percentage >= grade.cut_off_percentage
   	end
    return grades.last
  end

  #Instance Modules
  #---------------------------------------------------------------------------#
  #Returns the percentage of a particular subject in the current row wrt to the max marks of the same subject.
  def get_subject_percentage(subject_id)
  	hash = Mark.mark_columns_with_subject_ids(self.section)
  	return (self.send(hash[subject_id]) /Mark. get_max_marks(self.section_id, subject_id, self.exam_id))*100
  end
  
  #get_subject_percentages: will return a hash with key as the subject_id and value as the percentages for that particular mark record.
  def get_subject_percentages
  	percentages = {} 
  	hash = Mark.mark_columns_with_subject_ids(self.section)
  	hash.each do |sub_id, col_name|
  	  percentages[sub_id] = get_subject_percentage(sub_id)
  	end
  	return percentages
  end  
 
  # Retuns the grade object for a particular subject
  def get_grade(subject_id)
    p = get_subject_percentage(subject_id)
  	Mark.get_grade(p)
  end
  #rReturns the css style class of a particular subject in the current row. The style is determined using the percentage value
  def get_css_style(subject_id)
  	p = get_subject_percentage(subject_id)
  	g = Mark.get_grade(p)
	Mark.get_grade_css_style(g)
  end  
end
