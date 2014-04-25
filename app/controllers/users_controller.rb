class UsersController < ApplicationController
  before_filter :load_user, only: [:like, :unlike, :profile]

  def index
    @users = User.all
  end
  
  def show
    @user ||=  User.find(user_id)
  rescue Exception => each 
    redirect_to action: 'index'
  end

  def like
    market = Market.find(params[:market_id])
    @user.like(market)
    market.like(@user)
    render 'show'
  end

  def unlike
    market = Market.find(params[:market_id])
    @user.unlike(market)
    market.unlike(@user)
    render 'show'
  end

  def destroy
    @user = User.find(user_id)
    @user.destroy
    redirect_to action: 'index'
  end

  def desactivate
    UsersDomain.desactivate user_id
    redirect_to users_path
  end

  def change_role
    @user = User.find user_id
  end

  def update_role
    UsersDomain.update_role user_id, params[:new_role]
    redirect_to users_path
  end
  
  def subscription
    
  end

  private 

  def user_id
    params[:id]
  end

  def load_user
    @user = User.find(params[:user_id])
  end
end
