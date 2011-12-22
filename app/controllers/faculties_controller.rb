class FacultiesController < ApplicationController
  def new
  	@faculty = Faculty.new
  end

  def create
    @faculty = Faculty.new(params[:faculty])
    if @faculty.save
      redirect_to :controller => 'homes', :action => 'home'
    else
      render :new
    end
  end

  def update
    @faculty = Faculty.find(params[:id])
      if @faculty.update_attributes(params[:faculty])
        redirect_to :controller => 'homes', :action => 'home'
      else
        render :edit
      end
  end

  def edit
    @faculty = Faculty.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end    
   end
    
  def show
    @faculty = Faculty.find(params[:id])
  end

end
