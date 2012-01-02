class ResourcesController < ApplicationController
  skip_before_filter :set_tenant_branch
  
  def new
  	@title = "New Resource"
  	@resource = Resource.new
  end

  def index
    @resources = Resource.all
  end
  
  def create
    @resource = Resource.new(params[:resource])
    if @resource.save
      flash[:notice] = 'Resource successfully created'
      redirect_to @resource
    else
      render :new
    end
  end
  
  def show
  	@resource = Resource.find(params[:id])
  end
  
  def destroy
  	@resource = Resource.find(params[:id])
  	@resource.destroy
  	redirect_to resources_path
  end

  def update
    @resource = Resource.find(params[:id])
      if @resource.update_attributes(params[:resource])
      	flash[:notice] = 'Resource successfully updated'
        redirect_to @resource
      else
        render :edit
      end
  end

  def edit
    @resource = Resource.find(params[:id])
    @title = "Edit Resource"
  end
   
  def resource_typenew
  	@title = "New Resource Type"
    @resource = Resource.find(params[:id])
  end
  
  def resource_typecreate 
    @resource = Resource.find(params[:id])
    if @resource.update_attributes(params[:resource])
      flash[:notice] = "Resource types successfully created (updated)"
	  redirect_to @resource
    else
      render :resourcetypenew
    end
  end
  
end
