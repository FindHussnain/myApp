class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :show, :update, :destroy]
  before_action :authenticate_user, only:[:new, :create, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] do
    authorize_user(@article.user)
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      flash[:notice] = "Article was successfully created!"
      redirect_to article_path(@article)
    else
      flash[:alert] = @article.errors.full_messages
      render 'new'
    end
  end

  def show
    @comment = Comment.new
    @comments = @article.comments
  end

  def edit; end

  def update
    if @article.update(article_params)
      flash[:notice] = "Article was updated!"
      redirect_to article_path(@article)
    else
      flash[:danger] = @article.errors.full_messages
      render 'edit'
    end
  end

  def index
    @pagy, @articles = pagy(Article.all)
  end

  def destroy
    @article.destroy
    flash[:notice] = "Article was deleted"
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :user_id)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
