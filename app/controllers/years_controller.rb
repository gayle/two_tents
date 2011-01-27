class YearsController < ApplicationController
  def edit
    @years = Year.all # TODO sort this descending by year
  end

  def update
    Year.create(params[:year])
    redirect_to :action => 'edit'
  end

end
