class ParticipantsController < ApplicationController
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
    @participants = Participants.find(params[:id])
  end

  # POST /participants
  # POST /participants.xml
  def create
    @participants = Participant.new(params[:participants])

    respond_to do |format|
      if @participants.save
        flash[:notice] = 'Participants was successfully created.'
        format.html { redirect_to(@participants) }
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
      if @participants.update_attributes(params[:participants])
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

    respond_to do |format|
      format.html { redirect_to(participants_url) }
      format.xml  { head :ok }
    end
  end
end
