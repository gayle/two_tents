class FamiliesController < ApplicationController
  # GET /families
  # GET /families.xml
  def index
    @families = Families.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @families }
    end
  end

  # GET /families/1
  # GET /families/1.xml
  def show
    @families = Families.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @families }
    end
  end

  # GET /families/new
  # GET /families/new.xml
  def new
    @families = Families.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @families }
    end
  end

  # GET /families/1/edit
  def edit
    @families = Families.find(params[:id])
  end

  # POST /families
  # POST /families.xml
  def create
    @families = Families.new(params[:families])

    respond_to do |format|
      if @families.save
        flash[:notice] = 'Families was successfully created.'
        format.html { redirect_to(@families) }
        format.xml  { render :xml => @families, :status => :created, :location => @families }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @families.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /families/1
  # PUT /families/1.xml
  def update
    @families = Families.find(params[:id])

    respond_to do |format|
      if @families.update_attributes(params[:families])
        flash[:notice] = 'Families was successfully updated.'
        format.html { redirect_to(@families) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @families.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.xml
  def destroy
    @families = Families.find(params[:id])
    @families.destroy

    respond_to do |format|
      format.html { redirect_to(families_url) }
      format.xml  { head :ok }
    end
  end
end
