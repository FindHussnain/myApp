class UsersController < ApplicationController
	before_action :check_user, only: [:edit, :destroy]
	def new
		@user = User.new
	end
	def create
		@user =User.new(user_params)
		if @user.save
			flash[:success] = "Welcome to the alpha blog #{@user.username}"
			session[:user_id] = @user.id
			redirect_to articles_path
		else
			render 'new'
		end
	end
	def edit
		
	end
	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			flash[:success] = "Your account was updated successfully"
			redirect_to articles_path
		else
			render 'edit'
		end
	end
	def show
		@user = User.find(params[:id])
		@user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
	end
	def index
	    @users = User.paginate(page: params[:page], per_page: 5)
	end
	def destroy
		@user = User.find(params[:id])
		if current_user.has_role?(:admin) || current_user == @user
			@user.destroy
		else
			flash[:danger] = "You are not elligible for this"
		end
	end
private
	def user_params
		params.require(:user).permit(:username, :email, :password, {role_ids: []})
	end
	def check_user
		@user =User.find(params[:id])
		if !logged_in? || @user != current_user && !current_user.has_role?(:admin)
			flash[:danger] = "You are no eligible"
			redirect_to users_path
		end
	end
end
