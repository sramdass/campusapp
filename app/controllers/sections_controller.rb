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
  end
  
  def stunew
  	#@section = Section.find(params[:id])
	@default_tab = 'stunew'
	render :actions_box
  end
  
#-----------------------------------------------------------#

  def stucreate
  	 #@section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
		@default_tab='show'
			redirect_to(@section,  :notice => 'Students were successfully updated.')
    else
    	@default_tab = 'stunew'
        render :actions_box
    end
  end

#-----------------------------------------------------------#
  
  def marknew
  	#@section = Section.find(params[:id])
	@test = Test.find(params[:test_id]) || Test.first
  	@default_tab = 'marknew'	  	
	render :actions_box
  end
  
#-----------------------------------------------------------#

  def markcreate
  	 #@section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
		@default_tab='show'			
		redirect_to(@section,  :notice => 'Marks were successfully updated.')    	
    else
    	@default_tab = 'stunew'
        render :actions_box
    end
  end

#-----------------------------------------------------------#

def actions_box
	 #@section = Section.find(params[:id])
	@default_tab = 'show'
end
#-----------------------------------------------------------#

   def sort_column
    Section.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

#-----------------------------------------------------------#
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
#-----------------------------------------------------------#
  
	def mark_column(sub_id)
		temp_row = @section.sec_sub_maps.find_by_subject_id(sub_id)
		if temp_row.mark_column	
			return temp_row.mark_column
		else
			cols = (1..MARKS_SUBJECTS_COUNT).to_a
			@section.sec_sub_maps.each do |map|
			cols.delete_if {|x| x == map.mark_column}
			end			
			return cols[0] if !cols.empty?
			return -1	
		end	
	end
#-----------------------------------------------------------#	
	def initialize_test_and_marks_table
		@section ||= Section.find(params[:id])
		if params[:test_id]
			@test = Test.find(params[:test_id])
		else		
			@test = @section.tests.first
		end
		if @test
			build_marks_table(@section.id, @test.id)
		end
	end	
#-----------------------------------------------------------#

	def build_marks_table(section_id, test_id)
		@section = Section.find(section_id)
		marks = Mark.find(:all,:conditions => {:section_id.eq => section_id, :test_id.eq => test_id })
	 	if (marks.empty?)
	 		for student in @section.students 
	 			m = Mark.new( {:section_id => @section.id, :test_id => test_id, :student_id => student.id })
	 			m.save!
	 		end
		end 				
		if marks.count < @section.students.count
			@section.students.each do |student|
				mark = Mark.find(:all,:conditions => {:section_id.eq => section_id, :test_id.eq => test_id, :student_id => student.id })
				if (mark.empty?)
					m = Mark.new( {:section_id => @section.id, :test_id => test_id, :student_id => student.id })
					m.save!
				end
			end
		end
	end		
#-----------------------------------------------------------#	

	def delete_events(events)
		if !events.empty?
			events.each do |e|
				e.destroy
			end
		end
	end
			
end
