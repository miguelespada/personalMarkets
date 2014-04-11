class CommentsController < ApplicationController
  before_filter :load_market
  before_filter :load_comment, only: [:destroy, :update, :report]

  def create
    @comment = @market.comments.new(comment_params)
    @comment.author = current_user.email
    if @comment.save
      @user = @market.user
      redirect_to market_path @market
    end
  end

  def destroy
    authorize! :destroy, @comment
    @comment.destroy
    @user = @market.user
    redirect_to market_path @market
  rescue CanCan::AccessDenied
    render :status => :unauthorized, :text => "Unauthorized action" 
  end

  def update
    authorize! :update, @comment
    @comment.body = params[:body]
    @comment.save
    @user = @market.user
    render json: @comment
  rescue CanCan::AccessDenied
    render :status => :unauthorized, :text => "Unauthorized action" 
  end

  def report
    @comment.mark_as_reported
    redirect_to market_path @market, notice: "The comment was marked as reported"
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_market
    @market = Market.find(params[:market_id])
  end

  def load_comment
    @comment = @market.comments.find(params[:id])
  end
  
end
