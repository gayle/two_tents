class YearsController < ApplicationController
  def edit
    @years = Year.all # TODO sort this descending by year
  end

  def update
    @years_to_create = params[:new_year] || []
    @years_to_create.each do |year_params|
      Year.create!(year_params)
    end    

    # >>> START HERE, get existing years to update if necessary.
    redirect_to :action => 'edit'
  end

end
