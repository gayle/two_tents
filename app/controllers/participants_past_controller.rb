class ParticipantsPastController < ApplicationController
  before_filter :login_required


  def update
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

end
