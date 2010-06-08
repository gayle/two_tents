class ReportsController < ApplicationController
  # GET /reports
  def participants_by_age
    @participants_by_age = Participant.group_by_age
    respond_to do |format|
      format.html { render :action => "participants_by_age" }
    end
  end

end
