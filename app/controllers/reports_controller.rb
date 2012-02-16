class ReportsController < ApplicationController
  before_filter :login_required

  # GET /reports
  def participants_by_age
    @age_groups = AgeGroup.all(:order => "min ASC")
    respond_to do |format|
      format.html { render :action => "participants_by_age" }
    end
  end

  def participants_by_grade
    @participants_by_grade = Participant.group_by_grade
    respond_to do |format|
      format.html { render :action => "participants_by_grade" }
    end
  end

  def families_by_state
    @distinct_state_count = Family.count_by_state
    @families_by_state = Family.group_by_state
  end

  def birthdays_by_month
    @participants_by_birth_month = Participant.group_by_birth_month
  end

  def list_of_cds
    @families_with_photo_cds = Family.all_with_cds
    @total_cds = @families_with_photo_cds.collect {|f| f.number_of_photo_cds}.reduce(:+)
  end
end
