class CommentsController < ApplicationController

  def index
    @article = Article.find(params[:article_id])
    @comments = @article.comments
  end

  def edit
    @article = Article.find(params[:article_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @article = Article.find(params[:article_id])
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      flash[:success] = "Comment updated successfully"
      redirect_to article_path(@article)
    else
      render :edit
    end
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to article_path(@article)
    else
      redirect_to @article
    end
  end

  def show
    redirect_to article_path(Article.find(params[:article_id]))
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      redirect_to article_path(Article.find(params[:article_id]))
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
