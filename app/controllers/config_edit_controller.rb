class ConfigEditController < ApplicationController
  def index
    @config = Configuration.current
  end

  def update
    Configuration.create(params[:config])
    redirect_to :action => 'index'
  end

end
