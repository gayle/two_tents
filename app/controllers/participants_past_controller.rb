class ParticipantsPastController < ApplicationController
  before_filter :login_required

  def index
    #@past_participants = Participant.past.not_admin :order => "lastname ASC, firstname ASC"
    @past_participants = Participant.past.sort 
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
      begin
      @participant.add_current_year
      if @participant.update_attributes(params[:participant])
        AuditTrail.audit("Participant #{@participant.fullname} updated by #{current_user.login}", edit_participant_url(@participant))
        flash[:notice] = 'Participants was successfully updated.'
      else
        flash[:error] = format_flash_error("Error re-registering #{@participant.fullname}",
                                           "update(): #{@participant.errors.to_a.join(',')}")
        logger.error e.backtrace.join("\n\t")
      end
      format.html { redirect_to :action => "index" }
      rescue Exception => e
        flash[:error] = format_flash_error("Error updating #{@participant.fullname}", "update(): #{e.to_s} : #{e.backtrace[1]}")
        logger.error "ERROR updating participant \n#{@participant.inspect}"
        logger.error e.backtrace.join("\n\t")
        format.html { render :action => "index" }
    #    format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end


end
