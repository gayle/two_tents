class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
    @participants = Participant.find(:all)
  end
 
  def create
    logout_keeping_session!
    @participant = Participant.new(params[:participant])
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
        self.current_user = @user # !! now logged in
        redirect_back_or_default('/')
        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
        render :action => 'new'
      end
    else
      flash[:error] = "Problem with participant creation, please try again"
      render :action => 'new'
    end
  end
end
