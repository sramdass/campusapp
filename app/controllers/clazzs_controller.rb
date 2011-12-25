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

end
