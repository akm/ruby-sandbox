class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.create(params[:article])
    redirect_to articles_path, :notice => "New article created."
  end

end
