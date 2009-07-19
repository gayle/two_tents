class ParticipantsController < ApplicationController
  before_filter :login_required
  
  # GET /participants
  # GET /participants.xml
  def index
    @participants = Participant.all

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
    @participants = Participant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  # GET /participants/1/edit
  def edit
    @participant = Participant.find(params[:id])
  end

  # POST /participants
  # POST /participants.xml
  def create
    @family = Family.find(params[:participant][:family]) rescue nil
    params[:participant][:family] = @family
    @participants = Participant.new(params[:participant])

    respond_to do |format|
      if @participants.save
        flash[:notice] = 'Participants was successfully created.'
        format.html { params[:commit] == 'Save' ? redirect_to(@participants) : redirect_to(new_participant_path) }
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
    @participants = Participant.find(params[:id])

    respond_to do |format|
      if @participants.update_attributes(params[:participant])
        flash[:notice] = 'Participants was successfully updated.'
        format.html { redirect_to(@participants) }
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
    @participants.destroy
    
    flash[:error] = @participants.errors.full_messages

    respond_to do |format|
      format.html { redirect_to(participants_url) }
      format.xml  { head :ok }
    end
  end
end
