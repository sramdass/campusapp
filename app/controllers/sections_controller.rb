class SectionsController < ApplicationController

  def index
    if params[:clazz_id]
    	@sections = Clazz.find(params[:clazz_id]).sections
    else
    	@sections = Section.from_branch(current_profile.branch.id).all
    end
  end
  
  def new
  	@section = Section.new
  	@clazz = Clazz.find(params[:clazz_id])
  	@section.clazz = @clazz
  end

  def show
    @section = Section.find(params[:id])
  end
  
  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    params[:section][:subject_ids] ||= []
    params[:section][:exam_ids] ||= []
    		
    @section.attributes = params[:section]
    		
    @section.sec_sub_maps.each do |d|
      sid = d.subject_id
      d.attributes = 	{:subject_id => sid, :faculty_id => params["faculty"]["#{sid}"], :mark_column => ""}
    end			
	@section.sec_exam_maps.each do |semap|
	  eid = semap.exam.id
	  sdate = params["startdate"]["#{eid}"].to_date
	  edate = params["enddate"]["#{eid}"].to_date
	  semap.attributes = 	{ :exam_id => eid, :startdate => sdate, :enddate => edate}
	end	
    if @section.valid? && @section.sec_sub_maps.all?(&:valid?) && @section.sec_exam_maps.all?(&:valid?) 
      @section.save!
      @section.sec_sub_maps.each(&:save!)
      @section.sec_exam_maps.each(&:save!)
      redirect_to(@section,  :notice => 'Section was successfully updated.')
    else
      render :edit
    end
  end
  
  def create
    @section = Section.new(params[:section])
    #Only after the section is saved, we can get hold of the @section.sec_sub_maps.
    #Before the save, @section.sec_sub_maps and @section.sec_exam_maps will be blank.
    #We can try parsing the parameters and create the maps manually, but with the current
    #parameters they become duplicates, i.e. the current way of passing parameters from the
    #browser already creates the entries when we assign the parameters to the @section object.
    if @section.save
      @section.sec_sub_maps.each do |d|
        sid = d.subject_id
        #TODO: mark_column has to be updated once the mark tables are on.
        d.attributes = 	{:subject_id => sid, :faculty_id => params["faculty"]["#{sid}"], :mark_column => ""}
      end			
	  @section.sec_exam_maps.each do |semap|
	    eid = semap.exam.id
	    sdate = params["startdate"]["#{eid}"].to_date
	    edate = params["enddate"]["#{eid}"].to_date
	    semap.attributes = 	{ :exam_id => eid, :startdate => sdate, :enddate => edate}
	  end	    
      if @section.sec_sub_maps.all?(&:valid?) && @section.sec_exam_maps.all?(&:valid?) 
        @section.sec_sub_maps.each(&:save!)
        @section.sec_exam_maps.each(&:save!)
        redirect_to(@section,  :notice => 'Section successfully created.')
      else
      	#Section has been saved, but the subjects or exams have problem.
      	#TODO: change this to flash.now message
        render :new, :error => "Subjects and/or exams cannot be updated"
      end
    else
      #cannot save section itself
      render :new
    end
  end  
  
  def destroy
  	@section = Section.find(params[:id])
  	@section.delete
  	flash[:notice] = "Section Deleted"
  	#The redirection should happen to the previous page. We can delete the sections from the particular
  	#class or from the entire section index. So, the redirection should happen to the page from where the 
  	#delete happened.
  	redirect_to sections_path
  end
  
  def select
  	@branch=Branch.find(params[:branch_id])
  	@sections = Section.from_branch(@branch.id).all
  	@assign_students = @students_index = false
  	if params[:assign_students]
  	  @assign_students = true
  	elsif params[:student_index]
  	  @student_index = true
  	end
  end  
  
  def assign_students
  	@section=Section.find(params[:id])
  	@selected_student_id = params[:selected_student_id]
  	@deleted_student_id = params[:deleted_student_id]
  	#Make sure when a student is clicked more than once, it does not create any duplicate entries.
  	if @selected_student_id 
  	  if !SecStudentMap.for_student(@selected_student_id ).for_section(@section.id).all.empty? 
  	  	flash[:error] = "Student is already present in this section"
  	  	return
  	  end
  	  sec_student_map = @section.sec_student_maps.new(:student_id => @selected_student_id)  
  	  if sec_student_map.save
  	    respond_to do |format|
          format.html # assign_students.html.erb
          format.js
        end
      else
        flash[:error] = "Cannot assign the selected student to this section"
      end
    elsif @deleted_student_id
      #This will return only one entry as an array. Convert the array into a single element
      #Also, Make sure the same student id not called for delete twice (just by url, not by clicking) by checking for nil
      if del = SecStudentMap.for_student(@deleted_student_id ).for_section(@section.id).all.first  
      	del.delete
      end
    end
  end
  
  def studentnew
  	@section = Section.find(params[:id])
  end
  			
end
