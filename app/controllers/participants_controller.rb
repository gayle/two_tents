class ParticipantsController < ApplicationController
  before_filter :login_required
  
  # GET /participants
  # GET /participants.xml
  def index
    @participants = Participant.paginate :all, :page => params[:page], :order => "lastname ASC, firstname ASC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  # GET /participants/1
  # GET /participants/1.xml
  def show
    @participants = Participant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  # GET /participants/new
  # GET /participants/new.xml
  def new
    @participant = Participant.new 
  end

  def new_from_user
    @participant = Participant.new
    
  end

  # GET /participants/1/edit
  def edit
    @participant = Participant.find(params[:id])
  end

  def create_from_user
    @family = Family.find(params[:participant][:family]) rescue nil
    params[:participant][:family] = @family
    @participants = Participant.new(params[:participant])

    respond_to do |format|
      if @participants.save
        AuditTrail.audit("Participant #{@participants.fullname} created by #{current_user.login}", participant_url(@participants))
        flash[:notice] = 'Participants was successfully created.'
        format.html { redirect_to new_user_path(:participant => @participants) }
        format.xml  { render :xml => @participants, :status => :created, :location => @participants }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participants.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /participants
  # POST /participants.xml
  def create
    @family = Family.find(params[:participant][:family]) rescue nil
    params[:participant][:family] = @family
    @participants = Participant.new(params[:participant])

    respond_to do |format|
      if @participants.save
        AuditTrail.audit("Participant #{@participants.fullname} created by #{current_user.login}", edit_participant_url(@participants))
        flash[:notice] = 'Participants was successfully created.'
        format.html { params[:commit] == 'Save' ? redirect_to(participants_path) : redirect_to(new_participant_path) }
        format.xml  { render :xml => @participants, :status => :created, :location => @participants }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participants.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /participants/1
  # PUT /participants/1.xml
  def update
    debugger
    @participants = Participant.find(params[:id])

    respond_to do |format|
      if @participants.update_attributes(params[:participant])
        AuditTrail.audit("Participant #{@participants.fullname} updated by #{current_user.login}", edit_participant_url(@participants))
        flash[:notice] = 'Participants was successfully updated.'
        format.html { redirect_to(participants_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participants.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.xml
  def destroy
    @participants = Participant.find(params[:id])
    success = @participants.destroy

    if success and @participants.errors.empty?
      AuditTrail.audit("Participant #{@participants.fullname} destroyed by #{current_user.login}")
      flash[:success] = "Participant #{@participants.fullname} destroyed"
    else
      flash[:error] = @participants.errors.full_messages
    end
    respond_to do |format|
      format.html { redirect_to(participants_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    
  
  
end
