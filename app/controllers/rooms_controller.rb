class RoomsController < ApplicationController
  def index
    @rooms = Room.paginate :all, :page => params[:page], :order => "id asc"
  end

  def update
    params[:beds].each_pair do |k,v|
      Room.find(k).update_attribute(:beds, v)
    end
    redirect_to rooms_path
  end
end
