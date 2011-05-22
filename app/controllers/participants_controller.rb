class ParticipantsController < ApplicationController
  before_filter :login_required

  def registered_participants
    begin
      @participants = Participant.current.paginate :all, :page => params[:page], :order => "lastname ASC, firstname ASC"
    rescue Exception => e
      flash[:error] = format_flash_error("We're sorry, but something went wrong.", e.to_s)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  def ajax_review_past_participant
    # TODO handle exceptions here
    @participant = Participant.find(params[:id])
    render :action => "review"
  end

  # GET /participants
  # GET /participants.xml
  def index
    @past_participants = Participant.past.sort 
    @current_participants = Participant.current.not_admin :order => "lastname ASC, firstname ASC"
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
    @families = (Family.all || []).sort_by{ |f|  f.familyname  }
  end

  def new_choose_family
    puts "DBG params=#{params.inspect}"
    @family = Family.find(params["family"]["id"])
    @family.participants << Participant.new
    redirect_to edit_family_path(@family)
  end

  # GET /participants/1/edit
  def edit
    @participant = Participant.find(params[:id])
  end

  # GET /participants/1/review
  def review
    @participant = Participant.find(params[:id])
  end

  # POST /participants
  # POST /participants.xml
  def create
    @participant = Participant.new(params[:participant])

    respond_to do |format|
      if @participant.save
        AuditTrail.audit("Participant #{@participant.fullname} created by #{current_user.login}", edit_participant_url(@participant))
        flash[:notice] = "Participant #{@participant.fullname} was successfully created."
        # TODO: is this right? was new_user_path for this participant; test didn't match
        format.html { redirect_to participants_path }
      else
        flash[:error] = @participant.errors.full_messages.join(", ")
        format.html { render :action => "new" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  def unregister_past_participant
    @participant = Participant.find(params[:id])
    respond_to do |format|
      begin
        @participant.remove_current_year
        if @participant.save
          AuditTrail.audit("Participant #{@participant.fullname} un-registered by #{current_user.login}", edit_participant_url(@participant))
          flash[:notice] = 'Participant was unregistered for current year'
        else
          flash[:error] = format_flash_error("Error un-registering #{@participant.fullname}",
                                             "unregister_past_participant(): #{@participant.errors.to_a.join(',')}")
          logger.error @participant.errors.to_a
        end
      rescue Exception => e
        flash[:error] = format_flash_error("Error un-registerig #{@participant.fullname}",
                                           "unregister_past_participant(): #{e.to_s} : #{e.backtrace[1]}")
        logger.error "ERROR un-registering participant \n#{@participant.inspect}"
        logger.error e.backtrace.join("\n\t")
      end
      format.html { redirect_to :action => "index" }
    end
  end

  # PUT /participants/1
  # PUT /participants/1.xml
  def update
    @participant = Participant.find(params[:id])
    respond_to do |format|
      begin
        if @participant.update_attributes(params[:participant])
          AuditTrail.audit("Participant #{@participant.fullname} updated by #{current_user.login}", edit_participant_url(@participant))
          flash[:notice] = 'Participants was successfully updated.'
          format.html { redirect_to(participants_url) }
          format.xml  { head :ok }
        else
          flash[:error] = format_flash_error("Error updating #{@participant.fullname}",
                                             "participant update(): \n #{format_validation_errors(@participant.errors)}")
          format.html { render :action => "edit" }
          format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
        end
      rescue Exception => e
        flash[:error] = format_flash_error("Error updating #{@participant.fullname}", "participant update(): \n #{e.to_s}")
        logger.error "ERROR updating participant \n#{@participant.inspect}"
        logger.error e.backtrace.join("\n\t")
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_register
    @participant = Participant.find(params[:id])
    respond_to do |format|
      begin
        @participant.add_current_year
        if @participant.update_attributes(params[:participant])
          AuditTrail.audit("Participant #{@participant.fullname} updated by #{current_user.login}", edit_participant_url(@participant))
          flash[:notice] = 'Participants was successfully updated.'
        else
          flash[:error] = format_flash_error("Error re-registering #{@participant.fullname}",
                                             "update(): \n#{format_validation_errors(@participant.errors)}")
          logger.error e.backtrace.join("\n\t")
        end
        format.html { redirect_to :action => "index" }
      rescue Exception => e
        flash[:error] = format_flash_error("Error updating #{@participant.fullname}", "past participant update(): \n#{e.to_s} : #{e.backtrace[1]}")
        logger.error "ERROR updating participant \n#{@participant.inspect}"
        logger.error e.backtrace.join("\n\t")
        format.html { render :action => "index" }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.xml
  def destroy
    begin
      @participant_to_delete = Participant.find(params[:id])
      @family_to_delete = @participant_to_delete.family if @participant_to_delete.only_member_of_associated_family?

      # TODO look into whether this can be done in a validation, given that we only delete family if participant is only member.
      Participant.transaction do
        errors = []
        participant_deleted = @participant_to_delete.destroy
        family_deleted = nil
        if participant_deleted
          AuditTrail.audit("Participant #{@participant_to_delete.fullname} removed by #{current_user.login}")
          flash[:notice] = "Participant #{@participant_to_delete.fullname} deleted"
          if @family_to_delete
            family_name = @family_to_delete.familyname
            family_deleted = @family_to_delete.destroy
            if family_deleted
              AuditTrail.audit(
                      "Family #{family_name} removed by #{current_user.login} while deleting last family member #{@participant_to_delete.fullname}")
              flash[:success] = ", and family #{family_name} also deleted"
            else
              errors << @family_to_delete.errors.full_messages if @family_to_delete.errors
            end
          end
        else
          errors << @participant_to_delete.errors.full_messages if @participant_to_delete.errors
        end
        if not errors.blank?
          flash[:error] = errors
          logger.error errors.join("\n\t")
        end
      end
    rescue Exception => e
      flash[:error] = "Error deleting #{@participant_to_delete.fullname}: #{e.to_s}"
      logger.error "Error deleting #{@participant_to_delete.fullname}"
      logger.error e.backtrace.join("\n\t")
    end
    respond_to do |format|
      format.html { redirect_to(participants_url) }
      format.xml  { head :ok }
    end
  end
end
