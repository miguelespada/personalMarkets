class CommentsController < ApplicationController
  before_filter :load_market

  def create
    @comment = @market.comments.new(comment_params)
    @comment.author = current_user.email
    if @comment.save
      @user = @market.user
      redirect_to user_market_path(@user, @market)
    end
  end

  def destroy
    @comment = @market.comments.find(params[:id])
    @comment.destroy
    @user = @market.user
    redirect_to user_market_path(@user, @market)
  end

  def update
    @comment = @market.comments.find(params[:id])
    @comment.body = params[:body];
    @comment.save
    @user = @market.user
    render json: @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_market
    @market = Market.find(params[:market_id])
  end
  
end
