class MarksController < ApplicationController
  def subject_marks
  	@section_id = params[:section_id]
  	@exam_id = params[:exam_id]
  	@subject_id = params[:subject_id]
  	@section = Section.find(@section_id)
  	build_marks_table(@section_id, @exam_id)
  end


  def build_marks_table(section_id, exam_id)
    @section = Section.find(section_id)
    #Check if the number of rows for a particular exam + section combo in the marks table
    #is same as the number of students in that section.    
    marks = Mark.for_section(section_id).for_exam(exam_id)
    if (marks.count == 0)
      for student in @section.students 
        m = Mark.create!( {:section_id => @section.id, :exam_id => exam_id, :student_id => student.id })
      end
    end 				
    #If the number of records in the marks table is less than the number of students, create one
    #for the students that are left out.
    if marks.count < @section.students.count
      students = @section.students.map { |student| student.id } || []
      students_in_marks = Mark.for_section(section_id).for_exam(exam_id).for_student(student.id).select(:student_id).map {|mark| mark.student_id }
      (students - students_in_marks ).each do |student_id|
        m = Mark.create!( {:section_id => @section.id, :exam_id => exam_id, :student_id => student_id })
      end
    end	
  end
  
end
