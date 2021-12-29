class CommentsController < ApplicationController
  before_action :set_article, only: [:index, :edit, :update, :create ]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :update, :destroy, :new, :create]
  before_action only: [:edit, :update, :destroy] do
    authorize_user(@comment.user)
  end
  def index
    @comments = @article.comments
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "Comment updated successfully"
      redirect_to article_path(@article)
    else
      flash[:alert] = @comment.errors.full_messages
      render :edit
    end
  end

  def create
    @comment = @article.comments.create(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to article_path(@article)
    else
      flash[:alert] = @comment.errors.full_messages
      redirect_to @article
    end
  end

  def show
    redirect_to article_path(Article.find(params[:article_id]))
  end

  def destroy
    if @comment.destroy
      redirect_to article_path(Article.find(params[:article_id]))
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_article
      @article = Article.find(params[:article_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
