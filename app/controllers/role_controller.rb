class RoleController < ApplicationController

  def change
    @user = User.find user_id
  end

  def update
    UsersDomain.update_role user_id, params[:new_role]
    redirect_to users_path
  end

  private 

  def user_id
    params[:user_id]
  end

end