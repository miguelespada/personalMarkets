class StatusController < ApplicationController

  authorize_resource

  def update
    UsersDomain.update_status user_id, params[:new_status]
    redirect_to users_path
  end

  private

  def user_id
    params[:user_id]
  end

end