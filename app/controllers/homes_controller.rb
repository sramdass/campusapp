class HomesController < ApplicationController
  def home
    @branch = Branch.first
    if @branch
    	render :home
    else
    	redirect_to :controller => 'branches', :action => 'new'
    end
  end
  
  def branch_create
    @branch = Branch.new(params[:branch])
      if @branch.save
        redirect_to(@branch, :notice => 'Branch was successfully created.')
      else
        render :branch_new
      end
  end

end
