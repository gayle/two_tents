class AgeGroupsController < ApplicationController
  def index
#    debugger
    @age_groups = AgeGroup.all
    if @age_groups.empty?
      @age_groups << AgeGroup.new(:min => 0, :max => 5, :text => "0 - 5 years olds")
    end
  end

  def edit_all
    @age_groups = AgeGroup.all
    @age_groups << AgeGroup.new(:min => 0, :max => 5, :text => "Age 0 to 5") if @age_groups.empty?
  end

  def update_all
    @old_age_groups = AgeGroup.all
    age_groups = []
    i = 0
    num_groups = params[:num_age_groups].to_i
    while (i < num_groups)
      a = AgeGroup.new
      if (params.has_key?("min-#{i}"))
        a.min = params["min-#{i}"].to_i
        a.max = params["max-#{i}"].to_i
        a.text = params["text-#{i}"]
        age_groups << a
      end
      i+=1
    end
    AgeGroup.destroy_all
    age_groups.each do |ag|
      ag.save
    end
    redirect_to(edit_all_age_groups_path, :notice => "Age Groups Updated!")
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
