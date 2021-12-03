class ArticlesController < ApplicationController
	before_action :set_article, only: [:edit, :show, :update, :destroy]
	before_action :check_user, only:[:new, :edit, :update, :destroy]
	def new
		@article = Article.new
	end
	
	def create
		# render plain: params[:article][:title]
		@article = Article.new(article_params)
		@article.user = current_user
		if @article.save
			flash[:success] = "Article was successfully created!"
			redirect_to article_path(@article)
		else
			render 'new'
		end
	end

	def show
	end
	
	def edit
	end

	def update
		if @article.update(article_params)
			flash[:success] = "Article was updated!"
			redirect_to article_path(@article)
		else
			flash[:danger] = "Article was not updated"
			render 'edit'
		end
	end

	def index
		@articles = Article.paginate(page: params[:page], per_page: 5)
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy
		flash[:success] = "Article was deleted"
		redirect_to articles_path
	end

	private
		def article_params
			params.require(:article).permit(:title, :description, :user_id)
		end
		def set_article
			@article = Article.find(params[:id])
		end
		def check_user
			if !logged_in? || !current_user.has_role?(:editor || :admin)
				flash[:danger] = "You are not elligible for this action, signin first!"
				redirect_to articles_path
			end
		end
end
