class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :destroy, :show, :update]
  before_action :authenticate_user, only: [:edit, :update, :destroy]
  before_action only: [:destroy, :edit, :update] do
    authorize_user(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user =User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome to the Twitter Lite #{@user.username}"
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
    @pagy, @user_articles = pagy(Article.all)
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

  def set_user
    @user = User.find(params[:id])
  end
end
