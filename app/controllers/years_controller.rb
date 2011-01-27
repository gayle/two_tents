class YearsController < ApplicationController
  def edit
    @year = Year.current
  end

  def update
    Year.create(params[:year])
    redirect_to :action => 'index'
  end

end
