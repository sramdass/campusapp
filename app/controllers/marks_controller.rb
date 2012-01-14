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
    @exam = Exam.find(params[:exam_id])
  	if params[:subject_id]
  	  @subject = Subject.find(params[:subject_id])
  	end    	    
  	
  	#the mark_criteria will be created when the marks are updated for the first time, not when the marks_table is build when we call the mark_sheet.
  	#For each of the subject for this @section and @exam, create the mark criteria. If the params are not found, assign default values
    @section.sec_sub_maps.each do |ssmap|
      mc = MarkCriteria.find_or_create_by_section_id_and_subject_id_and_exam_id(@section.id, ssmap.subject_id, @exam.id)
      #assign in this order - param value or already existing value(if this is not a new record) or default value (if this is a new record and the params is blank)
      mc.max_marks = params[:max_marks]["#{ssmap.subject_id}"] || mc.max_marks || DEFAULT_MAX_MARKS  #default max_marks
      mc.pass_marks = params[:pass_marks]["#{ssmap.subject_id}"]  || mc.pass_marks || mc.max_marks * (DEFAULT_PASS_MARKS_PERCENTAGE / 100)  #default passmarks
      if !mc.save
      	flash.now[:error] = "Cannot update max marks or pass marks for  #{ssmap.subject.name.humanize}  Error: #{mc.errors.first}"
        render :marksheet
        return
      end
	end
    if @section.update_attributes(params[:section])
      redirect_to(@section,  :notice => 'Marks were successfully updated.')    	
    else
  	#Reinitialize the instance variable incase we need to render the marksheet again.
  	#These are passed as hidden variables from the views.
      render :marksheet, :error => "Cannot update marks for this section"
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
