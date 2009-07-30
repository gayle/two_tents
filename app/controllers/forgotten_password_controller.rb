class ForgottenPasswordController < ApplicationController
  def index
  end

  def retrieve_question
    users = User.find(:all,
      :conditions => ["login = ?", params[:login]])
    if users.length == 1
      @user = users[0]
    else
      flash[:error] = 'User could not be identified'
    end
  end

  def answer_question
    @user = User.find(params[:user][:id])
    if (@user.security_answer != params[:security_answer])
      flash[:error] = "Wrong answer!"
      redirect_back_or_default('/password')
    end
  end

end
