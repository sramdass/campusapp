class StudentsController < ApplicationController
  def index
  	@title = "Student Index"
  	@students = Student.all
  end

  def new
  	@title = 'New Student'
  	@student = Student.new
  end

  def create 
    @student = Student.new(params[:student])
    if @student.save
      flash[:notice] = "Student successfully created"
      redirect_to student_path(@student)
    else
      render :new
    end
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(params[:student])
      flash[:notice] = "Student successfully updated"
      redirect_to student_path(@student)
    else
      render :edit 
    end
  end

  def edit
  	@title = 'Edit Student'
    @student = Student.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end 
   end
    
  def show
    @student = Student.find(params[:id])
  end

end
