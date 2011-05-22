class AgeGroupsController < ApplicationController
  def index
#    debugger
    @age_groups = AgeGroup.all
    if @age_groups.empty?
      @age_groups << AgeGroup.new(:min => 0, :max => 5, :text => "0 - 5 years olds")
    end
  end

  def new
  end

  def create
    @age_group = AgeGroup.new(params[:age_group])
    if @age_group.save
      flash[:notice] = "Age group successfully created."
      redirect_to(age_groups_path)
    else
      render_showing_errors(:action => :new)
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
