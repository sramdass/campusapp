class BranchesController < ApplicationController
  def new
  	@branch = Branch.new
  end

  def create
    @branch = Branch.new(params[:branch])
    if @branch.save
      redirect_to :controller => 'homes', :action => 'home'
    else
      render :new
    end
  end

  def update
    @branch = Branch.find(params[:id])
      if @branch.update_attributes(params[:branch])
        redirect_to :controller => 'homes', :action => 'home'
      else
        render :edit
      end
  end

  def edit
    @branch = Branch.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end    
   end
  
end
