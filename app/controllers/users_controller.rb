class UsersController < ApplicationController
  before_filter :find_user, :only => [:edit, :update, :destroy, :answer_question, :reset_password]

  require_role "admin", :for => [:new, :create, :destroy]
  require_role "admin", :for => [:update, :edit], :unless => "current_user.authorized_for_listing?(params[:id])"

  # render new.rhtml
  def new
    @user = User.new
    @participants = Participant.find_non_staff_participants
    @participant = params[:participant].to_i
  end

  def create
    if not params[:user][:participant].blank?
      @participant = Participant.find(params[:user][:participant])
      params[:user].delete(:participant)
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
    @participant = @user.participant
    @participants = Participant.find_non_staff_participants
    @participants.unshift(@user.participant)
  end

  def update
    @participant = (params[:user][:participant]).blank? ? @user.participant : Participant.find(params[:user][:participant])
    # Once we have participant form attributes partial rendered on the same page, update attributes
    # @participant.update_attributes(params[])
    success = @participant && @participant.save
    if success && @participant.errors.empty?
      params[:user][:participant] = @participant
      params[:user][:password] = "" if params[:user][:password_confirmation].blank?
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
    if (@user.destroy)
      AuditTrail.audit("Family #{@family.familyname} destroyed by #{current_user.login}")
      flash[:notice] = "User #{@user.login} destroyed"
    else
      flash[:error] = "Failed to destroy #{@user.login}"
    end
    redirect_to :users
  end

  def reset_login
    render :template => 'users/enter_login'
  end

  def enter_login
    @user = User.find_by_login(params[:user][:login])
    if @user
      render :template => 'users/answer_question'
    else
      flash.now[:error] = "That username could not be found."
    end
  end

  def answer_question
    @user = User.find(params[:id])
    if (@user.security_answer == params[:user][:security_answer])
      render :template => 'users/change_password'
    else
      flash.now[:error] = "Your answer did not match the answer we have."
    end
  end

  def show_password
    @user = User.find(params[:id])
    render :template => 'users/change_password'
  end

  def change_password
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      flash[:success] = "Your password has been reset!"
      if current_user
        redirect_to staff_path
      else
        redirect_to login_path
      end
    else
      flash.now[:error] = @user.errors.full_messages
    end
  end

  def find_user
    @user = User.find(params[:id])
  end
end
