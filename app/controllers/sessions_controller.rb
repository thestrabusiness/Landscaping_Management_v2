class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create], raise: false

  def new
  end

  def create
    user = authenticate_session(session_params)

    if user.approved? && sign_in(user)
      redirect_to root_path
    else
      flash.now[:error] = 'You entered the wrong user name or password, or you account has not been approved.'
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to new_session_path, error: 'You were signed out'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
