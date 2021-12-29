class ApplicationController < ActionController::Base
  include Pagy::Backend
  Pagy::DEFAULT[:items]  = 10
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end

  def authenticate_user
    if !logged_in?
      flash[:alert] = "You are not elligible for this action, signin first!"
      redirect_to login_path
    end
  end

  def authorize_user(user)
    if user != current_user && !current_user.admin?
      flash[:alert] = "You are elligible, signin with authrize account"
      redirect_to articles_path
    end
  end
end
