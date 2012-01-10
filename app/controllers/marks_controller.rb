class MarksController < ApplicationController
  def marksheet
  	#The marksheet view will display mark fields for all the subjects or for a particular subject 
  	#(for the @exam + @section combination). If the @subject is not nil, the view will display
  	# fields only for this subject.
  	@section = Section.find(params[:section_id])
  	@exam = Exam.find(params[:exam_id])
  	if params[:subject_id]
  	  #When the subject is nil, the view will display the fields for all the subjects
  	  @subject = Subject.find(params[:subject_id])
  	end
  	build_marks_table(@section.id, @exam.id)
  end
  
  def section_markcreate
    @section = Section.find(params[:section_id])
    if @section.update_attributes(params[:section])
      redirect_to(@section,  :notice => 'Marks were successfully updated.')    	
    else
  	#Reinitialize the instance variable incase we need to render the marksheet again.
  	#These are passed as hidden variables from the views.
    @exam = Exam.find(params[:exam_id])
  	if params[:subject_id]
  	  @subject = Subject.find(params[:subject_id])
  	end    	
      render :marksheet
    end
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
