class UsersController < ApplicationController
  
  # render new.rhtml
  def new
    @user = User.new
    @participants = Participant.find_non_staff_participants
  end
 
  def create
    if params[:user][:participant]
      @participant = Participant.find(params[:user][:participant])
      # Once we have participant form attributes partial rendered on the same page, update attributes
      # @participant.update_attributes(params[])
    else
      # Once we have participant form attributes partial rendered on the same page, use form params to create new obj
      @participant = Participant.new()
    end 
    success = @participant && @participant.save
    if success && @participant.errors.empty?
      @user = User.new(params[:user])
      @user.participant = @participant
      success = @user && @user.save
      if success && @user.errors.empty?
        # Protects against session fixation attacks, causes request forgery
        # protection if visitor resubmits an earlier form using back
        # button. Uncomment if you understand the tradeoffs.
        # reset session
        redirect_to :action => 'index'
        flash[:notice] = "#{@user.participant.fullname} registered as a staff member."
      else
        @participants = Participant.find_non_staff_participants
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
        render :action => 'new'
      end
    else
      @participants = Participant.find_non_staff_participants
      flash[:error] = "Problem with participant creation, please try again"
      render :action => 'new'
    end
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  def edit
    @user = User.find(params[:id])
    @participants = Participant.find_non_staff_participants
    @participants.unshift(@user.participant)
  end

  def update
    @user = User.find(params[:id])
    @participant = Participant.find(params[:user][:participant])
    # Once we have participant form attributes partial rendered on the same page, update attributes
    # @participant.update_attributes(params[])
    success = @participant && @participant.save
    if success && @participant.errors.empty?
      params[:user][:participant] = @participant
      params[:user][:password] = "" if params[:user][:password_confirmation].empty? 
      begin
        User.transaction do
          @user.update_attributes!(params[:user])
          @user && @user.save!
          redirect_to :action => 'index'
        end
      rescue
        flash[:error] = @user.errors.full_messages + @participant.errors.full_messages
        redirect_to :action => 'edit', :user => @user
      end
    else
      flash[:error] = "Problem with participant creation, please try again"
      render :action => 'edit'
    end

  end

end
