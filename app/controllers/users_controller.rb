class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def show
    @user = User.find(params[:id])
  	rescue Exception => each 
  		redirect_to action: 'index'
  end
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to action: 'index'
  end
end
