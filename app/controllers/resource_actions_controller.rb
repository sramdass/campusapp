class ResourceActionsController < ApplicationController
  skip_before_filter :set_tenant_branch
  
  def new
  	@title = "New Resource Action"
  	@resource_action = ResourceAction.new
  end

  def index
    @resource_actions = ResourceAction.all
  end
  
  def create
    @resource_action = ResourceAction.new(params[:resource_action])
    if @resource_action.save
      flash[:notice] = 'Resource Action successfully created'
      redirect_to @resource_action
    else
      render :new
    end
  end
  
  def show
  	@resource_action = ResourceAction.find(params[:id])
  end
  
  def destroy
  	@resource_action = ResourceAction.find(params[:id])
  	@resource_action.destroy
  	redirect_to resource_actions_path
  end

  def update
    @resource_action = ResourceAction.find(params[:id])
      if @resource_action.update_attributes(params[:resource_action])
      	flash[:notice] = 'Resource Action successfully updated'
        redirect_to @resource_action
      else
        render :edit
      end
  end

  def edit
    @resource_action = ResourceAction.find(params[:id])
    @title = "Edit Resource Action"
  end
   
end
