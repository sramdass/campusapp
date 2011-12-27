class BranchesController < ApplicationController
  skip_before_filter :set_tenant_branch
  
  def new
  	@title = "New Branch"
  	@branch = Branch.new
  end

  def create
    @branch = Branch.new(params[:branch])
    if @branch.save
      flash[:notice] = 'Branch successfully created'
      redirect_to dashboard_path
    else
      render :new
    end
  end
  
  def show
  	@branch = Branch.find(params[:id])
  end

  def update
    @branch = Branch.find(params[:id])
      if @branch.update_attributes(params[:branch])
      	flash[:notice] = 'Branch successfully updated'
        redirect_to dashboard_path
      else
        render :edit
      end
  end

  def edit
    @branch = Branch.find(params[:id])
    @title = "Edit Branch"
  end
   
  def facultynew
  	@title = "New Faculty"
    @branch = Branch.find(params[:id])
  end
  
  def facultycreate 
    @branch = Branch.find(params[:id])
    if @branch.update_attributes(params[:branch])
      flash[:notice] = "Faculties successfully created (updated)"
	  redirect_to dashboard_path
    else
      render :facultynew
    end
  end
  
  def clazznew
  	@title = "New Class"  	
    @branch = Branch.find(params[:id])
  end
  
  def clazzcreate
    @branch = Branch.find(params[:id])
    if @branch.update_attributes(params[:branch])
	  redirect_to dashboard_path
      flash[:notice] = "Classes successfully created (updated)"	  
    else
      render :clazznew
    end
  end  
  
  def subjectnew
  	@title = "New Subject"  	
    @branch = Branch.find(params[:id])
  end
  
  def subjectcreate
    @branch = Branch.find(params[:id])
    if @branch.update_attributes(params[:branch])
      flash[:notice] = "Subjects successfully created (updated)"    	
	  redirect_to dashboard_path
	else
      render :subjectnew
    end
  end  
 
end
