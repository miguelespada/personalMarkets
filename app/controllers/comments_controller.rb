class CommentsController < ApplicationController
  before_filter :load_user

  def create
    @market = Market.find(params[:market_id])
    @comment = @market.comments.new(comment_params)
    if @comment.save
      @user = @market.user
      redirect_to user_market_path(@user, @market)
    end
  end

  def destroy
    @market = Market.find(params[:market_id])
    @comment = @market.comments.find(params[:id])
    @comment.destroy
    @user = @market.user
    redirect_to user_market_path(@user, @market)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def load_user
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    end 
  end
  
end
