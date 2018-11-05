class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = sign_up(user_params)

    if @user.persisted? && @user.approved?
      sign_in(@user)
      redirect_to root_path
    elsif @user.persisted? && !@user.approved?
      redirect_to new_session_path, notice: 'Account created successfully. Please wait for admin approval before logging in'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :approved)
  end
end
