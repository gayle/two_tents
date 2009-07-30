class UsersController < ApplicationController
  require_role "admin", :for => [:new, :create, :destroy]
  require_role "admin", :for => [:update, :edit], :unless => "current_user.authorized_for_listing?(params[:id])"

  # render new.rhtml
  def new
    @user = User.new
    @participants = Participant.find_non_staff_participants
    @participant = params[:participant].to_i
  end

  def create
    if params[:user][:participant]
      @participant = Participant.find(params[:user][:participant])
      params[:user].delete(:participant)
      # Once we have participant form attributes partial rendered on the same page, update attributes
      # @participant.update_attributes(params[])
    else
      # Once we have participant form attributes partial rendered on the same page, use form params to create new obj
      @participant = Participant.new()
    end

    params[:user][:participant] = @participant
    @user = User.new(params[:user])
    @user.participant = @participant
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      AuditTrail.audit("User #{@user.login} created by #{current_user.login}", user_url(@user))
      flash[:notice] = "#{@user.participant.fullname} registered as a staff member."
      redirect_to :action => 'index'
    else
      flash[:error]  = @user.errors.full_messages
      AuditTrail.audit("Creation of user #{@user.login} failed, attempted by #{current_user.login}")
      @participants = Participant.find_non_staff_participants
      render :action => 'new'
    end
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.paginate :all, :page => params[:page], :order => 'login ASC'

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
          AuditTrail.audit("User #{@user.login} updated by #{current_user.login}", edit_user_url(@user))
          flash[:notice] = "#{@user.participant.fullname} updated."
          redirect_to :action => 'index'
        end
      rescue
        flash[:error] = "Problem with participant creation, please correct the errors and try again."
        redirect_to :action => 'edit', :user => @user
      end
    else
      flash[:error] = "Problem with participant creation, please correct the errors and try again."
      render :action => 'edit'
    end

  end

  def destroy
    @user = User.find(params[:id])
    if (@user.destroy)
      AuditTrail.audit("Family #{@family.familyname} destroyed by #{current_user.login}")
      flash[:notice] = "User #{@user.login} destroyed"
    else
      flash[:error] = "Failed to destroy #{@user.login}"
    end
    redirect_to :users
  end
end
