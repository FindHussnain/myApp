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
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You must be logged in to perform that action" }
      end
    end
  end

  def authenticate_user
    if !logged_in?
      respond_to do |format|
        format.html { redirect_to login_path, alert: "You are not elligible for this action, signin first!" }
      end
    end
  end

  def authorize_user(user)
    if user != current_user && !current_user.admin?
      respond_to do |format|
        format.html { redirect_to articles_path, alert: "You are elligible, signin with authorize account" }
      end
    end
  end
end
