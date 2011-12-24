class ClazzsController < ApplicationController

  # GET /clazzs
  # GET /clazzs.xml
  def index
  	@clazzs = Clazz.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clazzs }
      format.js
    end
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
    respond_to do |format|
      if @clazz.save
        format.html { redirect_to(@clazz, :notice => 'Class was successfully created.') }
        format.xml  { render :xml => @clazz, :status => :created, :location => @clazz }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clazz.errors, :status => :unprocessable_entity }
      end
    end
  end


end
