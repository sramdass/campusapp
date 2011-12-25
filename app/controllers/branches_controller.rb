class BranchesController < ApplicationController
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
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end    
   end
   
  def facultynew
    @branch = Branch.find(params[:id])
  end
  
  def facultycreate
    @branch = Branch.find(params[:id])
    if @branch.update_attributes(params[:branch])
	  redirect_to dashboard_path
    else
      render :facultynew
    end
  end
  
  def clazznew
    @branch = Branch.find(params[:id])
  end
  
  def clazzcreate
    @branch = Branch.find(params[:id])
    if @branch.update_attributes(params[:branch])
	  redirect_to dashboard_path
    else
      render :clazznew
    end
  end  
 
end
