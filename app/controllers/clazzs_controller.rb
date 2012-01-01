class ClazzsController < ApplicationController

  def index
  	@clazzs = Clazz.all
  end

  def show
    @clazz = Clazz.find(params[:id])
  end

  def new
    @clazz = Clazz.new
  end

  def edit
    @clazz = Clazz.find(params[:id])
  end

  def create
    @clazz = Clazz.new(params[:clazz])
    @clazz.year = current_year
    if @clazz.save
      redirect_to(@clazz, :notice => 'Class was successfully created.') 
    else
      render :new
    end
  end

  def update
    @clazz = Clazz.find(params[:id])
    if @clazz.update_attributes(params[:clazz])
      redirect_to @clazz, :notice => 'Clazz was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @clazz = Clazz.find(params[:id])
    @clazz.destroy
     redirect_to clazzs_path
  end
  
  def sectionnew
    @clazz = Clazz.find(params[:id])
  	@faculties = @clazz.branch.faculties
  end
  
  def sectioncreate
    @clazz = Clazz.find(params[:id])
    if @clazz.update_attributes(params[:clazz])
	  redirect_to(@clazz	, :notice => ' Sections were successfully updated.') 
    else
	  render :sectionnew      	        
    end
  end  
  
  def select
  	@branch=Branch.find(params[:branch_id])
  	@clazzs = @branch.clazzs
  	@quick_add_section = @section_index = @add_section = false
  	if params[:quick_add_section]
  	  @quick_add_section = true
  	elsif params[:section_index]
  	  @section_index = true
  	elsif params[:add_section]
  	  @add_section = true
  	end
  end

end
