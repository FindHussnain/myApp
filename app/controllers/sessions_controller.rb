class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user  && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "You are logged in successfully."
      redirect_to users_path(user)
    else
      flash.now[:alert] = "Invalid email or password"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have logged out"
    redirect_to articles_path
  end
end
