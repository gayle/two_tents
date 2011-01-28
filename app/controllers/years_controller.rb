class YearsController < ApplicationController
  def edit
    @years = Year.all # TODO sort this descending by year
  end

  def update
    # >>> START HERE, get the years to save. (create or update)
    @years = params[:new_year] || []
    puts
    @years.each do |year|
      puts "DBG year=#{year.inspect}"
      puts
#      Year.create(year)
    end    
    redirect_to :action => 'edit'
  end

end
