class ParticipantsController < ApplicationController
  before_filter :login_required
  
  # GET /participants
  # GET /participants.xml
  def index
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

  def participants_past
    @past_participants = Participant.past :order => "lastname ASC, firstname ASC"
    @current_participants = Participant.current

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

  # GET /participants/1/edit
  def edit
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

  # PUT /participants/1
  # PUT /participants/1.xml
  def update
    @participant = Participant.find(params[:id])
    respond_to do |format|
      if @participant.update_attributes(params[:participant])
        AuditTrail.audit("Participant #{@participant.fullname} updated by #{current_user.login}", edit_participant_url(@participant))
        flash[:notice] = 'Participants was successfully updated.'
        format.html { redirect_to(participants_url) }
        format.xml  { head :ok }
# I don't think we're using this anymore?
#        format.js   do
#          flash.discard
#          render(:update) do |page|
#            element = "#{@participant.class}_#{@participant.id}_#{params[:participant].keys[0]}"
#            page.replace_html(element,
#                              :partial => 'flipflop',
#                              :locals => {:p => @participant,
#                                :type => params[:participant].keys[0] } )
#          end
#        end
      else
        flash[:error] = format_flash_error("Error updating #{@participant.fullname}",
                                           "update(): #{@participant.errors.to_a.join(',')}")
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  rescue Exception => e
    flash[:error] = format_flash_error("Error updating #{@participant.fullname}", "update(): #{e.to_s}")
    logger.error "ERROR updating participant \n#{@participant.inspect}"
    logger.error e.backtrace.join("\n\t")
    format.html { render :action => "edit" }
    format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
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
              flash[:success] << ", and family #{family_name} also deleted"
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
