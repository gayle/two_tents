class UsersController < ApplicationController
  before_filter :find_user, :only => [:edit, :update, :destroy, :answer_question, :reset_password]

  before_filter :login_required, :except => [:reset_login, :enter_login, :answer_question, :change_password]

#  require_role "user", :for_all_except => [:reset_login, :enter_login, :answer_question, :change_password]
#    require_role "admin", :for => [:update, :edit], :unless => "current_user.authorized_for_listing?(params[:id])"

  def new
    @user = User.new
    if params[:participant]
      @user.participant = Participant.find(params[:participant])
    else
      @user.build_participant
    end
  end

  def create
    @user = User.new
    @user.build_participant
    #HACK - change habtm to has_many :through => :rich_join_model.  See https://github.com/gayle/two_tents/issues#issue/52
    @user.roles << Role.find_or_create_by_name(:name => "staff")
    @user.roles << Role.find_or_create_by_name(:name => "admin") if params[:user][:admin_role] == '1'
    @user.attributes = params[:user]
    if @user.save
      AuditTrail.audit("User '#{@user.participant.fullname}' (#{@user.login}) created by user #{current_user.login}", user_url(@user))
      flash[:notice] = "'#{@user.participant.fullname}' (#{@user.login}) is now registered as #{@user.roles.collect { |x| x.name }.join(', ')}"
      redirect_to :action => 'index'
    else
      flash[:error]  = "there was an error saving this staff member"
      AuditTrail.audit("Creation of user '#{@user.login}' failed, attempted by user #{current_user.login}")
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
    @participants = Participant.find_non_staff_participants
    @participants << @user.participant
  end

  def update
    if @user.update_attributes(params[:user])
      AuditTrail.audit("User '#{@user.participant.fullname}' (#{@user.login}) updated by user #{current_user.login}", edit_user_url(@user))
      flash[:notice] = "User '#{@user.participant.fullname}' (#{@user.login}) updated."
      redirect_to :action => 'index'
    else
      flash[:error] = "Problem with participant creation, please correct the errors and try again."
      redirect_to :action => 'edit', :user => @user
    end
  end

  def destroy
    user_full_name = @user.participant.fullname
    user_login = @user.login
    if @user.destroy
      AuditTrail.audit("User '#{user_full_name}' (#{user_login}) removed by user #{current_user.login}")
      flash[:notice] = "User '#{user_full_name}' (#{user_login}) deleted"
    else
      flash[:error] = "Failed to destroy #{user_login}"
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

    if User.authenticate(@user.login, params[:current_password]).nil?
      flash.now[:error] = "Current password incorrect"
      return
    end

    @user.update_attributes(params[:user])
    if @user.save
      flash[:success] = "Your password has been reset!"
      if current_user
        redirect_to dashboard_path
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
