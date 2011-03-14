class ParticipantsPastController < ApplicationController
  before_filter :login_required

  def index
    @past_participants = Participant.past.not_admin :order => "lastname ASC, firstname ASC"
    @current_participants = Participant.current.not_admin :order => "lastname ASC, firstname ASC"
  end

  def ajax_review_past_participant
    # TODO handle exceptions here
    @participant = Participant.find(params[:id])
    render :action => "edit"
  end

  def update
    puts
    puts
    puts "DBG participants_past_update params=#{params.inspect}"
    puts
    @participant = Participant.find(params[:id])
    respond_to do |format|
      if @participant.update_attributes(params[:participant])
        AuditTrail.audit("Participant #{@participant.fullname} updated by #{current_user.login}", edit_participant_url(@participant))
        flash[:notice] = 'Participants was successfully updated.'
#        format.html { redirect_to(participants_past_url) }
#        format.xml  { head :ok }
      else
        flash[:error] = format_flash_error("Error re-registering #{@participant.fullname}",
                                           "update(): #{@participant.errors.to_a.join(',')}")
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
#      puts "DBG redirecting to #{participants_past_url}"
#      format.html { redirect_to(participants_past_url) }
      format.html { redirect_to :action => "index" }
    end
  rescue Exception => e
    flash[:error] = format_flash_error("Error updating #{@participant.fullname}", "update(): #{e.to_s}")
    logger.error "ERROR updating participant \n#{@participant.inspect}"
    logger.error e.backtrace.join("\n\t")
    format.html { render :action => "index" }
#    format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }

  end


end
