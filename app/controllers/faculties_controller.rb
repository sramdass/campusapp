class FacultiesController < ApplicationController
  def index
  	@title = "Faculty Index"
  	@faculties = Faculty.all
  end

  def new
  	@title = 'New Faculty'
  	@faculty = Faculty.new
  	@faculty.build_detail
  end

  def create 
    @faculty = Faculty.new(params[:faculty])
    @faculty.branch = current_profile.branch
    if @faculty.save
      flash[:notice] = "Faculty successfully created"
      redirect_to faculty_path(@faculty)
    else
      render :new
    end
  end

  def update
    @faculty = Faculty.find(params[:id])
    if @faculty.update_attributes(params[:faculty])
      flash[:notice] = "Faculty successfully updated"
      redirect_to faculty_path(@faculty)
    else
      render :edit 
    end
  end

  def edit
  	@title = 'Edit Faculty'
    @faculty = Faculty.find(params[:id])
    @faculty.build_detail if !@faculty.detail
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end 
   end
    
  def show
    @faculty = Faculty.find(params[:id])
  end

end
