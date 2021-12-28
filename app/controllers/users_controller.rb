class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :show, :update]
  before_action :authenticate_user, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:destroy, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user =User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome to the alpha blog #{@user.username}"
      session[:user_id] = @user.id
      redirect_to articles_path
    else
      flash[:alert] = @user.errors.full_messages
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account was updated successfully"
      redirect_to articles_path
    else
      flash[:alert] = @user.errors.full_messages
      render 'edit'
    end
  end

  def show
    @pagy, @user_articles = pagy(Article.all, items: 5)
  end

  def index
    @pagy, @users = pagy(User.all)
  end

  def destroy
    if current_user.has_role?(:admin) || current_user == @user
      @user.destroy
    else
      flash[:alert] = "You are not elligible for this"
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, {role_ids: []})
  end

  def authenticate_user
    @user = User.find(params[:id])
    if !logged_in?
      flash[:alert] = "You are no eligible"
      redirect_to users_path
    end
  end

  def authorize_user
    if  @user != current_user && !current_user.admin?
      flash[:alert] = "you are not eligible"
      redirect_to users_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end
end
