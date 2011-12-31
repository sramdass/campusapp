class ExamsController < ApplicationController

  def index
  	@exams = Exam.all
  end

  def show
    @exam = Exam.find(params[:id])
  end

  def new
    @exam = Exam.new
  end

  def edit
    @exam = Exam.find(params[:id])
  end

  def create
    @exam = Exam.new(params[:exam])
    @exam.year = current_year
    if @exam.save
      redirect_to(@exam, :notice => 'Exam was successfully created.') 
    else
      render :new
    end
  end

  def update
    @exam = Exam.find(params[:id])
    if @exam.update_attributes(params[:exam])
      redirect_to @exam, :notice => 'Exam was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
     redirect_to exams_path
  end

end
