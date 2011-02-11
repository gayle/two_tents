class YearsController < ApplicationController
  def edit
    @years=[] # so we never have nil @years
    begin
      @years = Year.all.sort_by { |a| -a.year }
    rescue Exception => e
      flash[:error] = e.to_s #format_flash_error("Error showing years", e.to_s)
    end
  end

  def update
    begin
      @years_to_create = params[:new_year] || []
      @years_to_create.each do |year_params|
        Year.create!(year_params)
      end
      Rails.logger.debug("new records for year created: #{@years.inspect}")

      Year.update_multiple!(params[:year]) if params[:year]
      Rails.logger.debug("existing records for year updated: #{@years.inspect}")

      flash[:notice] = "Years saved successfully"
    rescue Exception => e
      flash[:error] = format_flash_error("Error updating years", "update(): #{e.to_s}")
      Rails.logger.error "ERROR updating years"
      Rails.logger.error e.backtrace.join("\n\t")
      format.html { render :action => "edit" }
      format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
    end
    redirect_to :action => 'edit'
  end

end
