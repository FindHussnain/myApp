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
    respond_to do |format|
      if @article.save
        format.html { redirect_to article_path(@article), notice: "Article was successfully created!" }
      else
        flash[:alert] = @article.errors.full_messages
        format.html { render 'new', status: :unprocessable_entity }
      end
    end
  end

  def show
    @comment = Comment.new
    @comments = @article.comments
  end

  def edit; end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_path(@article), notice: "Article was updated!" }
      else
        flash[:alert] = @article.errors.full_messages
        format.html { render 'edit', status: :unprocessable_entity }
      end
    end
  end

  def index
    @pagy, @articles = pagy(Article.all)
  end

  def destroy
    respond_to do |format|
      @article.destroy
      format.html { redirect_to articles_path, notice: "Article was deleted" }
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :user_id)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
