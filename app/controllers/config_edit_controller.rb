class ConfigEditController < ApplicationController
  def index
    @config = Configuration.current
  end

  def update
    Configuration.create(params[:configuration])
  end

end
