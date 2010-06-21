class ReportsController < ApplicationController
  before_filter :login_required

  # GET /reports
  def participants_by_age
    @participants_by_age = Participant.group_by_age
    respond_to do |format|
      format.html { render :action => "participants_by_age" }
    end
  end

  def families_by_state
    @distinct_state_count = Family.count_by_state
    @families_by_state = Family.group_by_state
  end
end
