class FilesController < ApplicationController
  def index
    @files = Files.paginate :all, :page => params[:page], :order => "created_at desc"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @files }
    end
  end

  def create
    @file = Files.new(params[:files])
    respond_to do |format|
      if @file.save
        AuditTrail.audit("File #{@file.description} uploaded by #{current_user.login}")
        
        flash[:notice] = 'File was successfully uploaded.'
        format.html { redirect_to(files_path) }
        format.xml  { render :xml => @files, :status => :created, :location => @files }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @files.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @file = Files.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @file }
    end
  end

  def destroy
    @file = Files.find(params[:id])
    @file.destroy
    AuditTrail.audit("File #{@file.description} destroyed by #{current_user.login}")
    
    respond_to do |format|
      format.html { redirect_to(files_url) }
      format.xml  { head :ok }
    end
  end
end
