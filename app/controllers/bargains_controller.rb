class BargainsController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:show, :index, :list_user_bargains, :gallery]

  def index
    @bargains = Bargain.all
    respond_to do |format|
        format.html
        format.json {render json: @bargains}
    end
  end

  def gallery
    @bargains = Bargain.all
    render layout: false
  end

  def list_user_bargains
    @bargains = load_user.bargains.all
    render "index"
  end

  def new
    @bargain = Bargain.new
  end

  def edit
  end

  def create
    @bargain = Bargain.new(bargain_params)
    @bargain.user = current_user
    current_user.bargains << @bargain
    respond_to do |format|
      if @bargain.save
        format.html { redirect_to user_bargains_path(current_user), notice: 'Bargain was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @bargain.update(bargain_params)
        format.html { redirect_to user_bargains_path(current_user), notice: 'Bargain was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @bargain.destroy
        format.html { redirect_to user_bargains_path(current_user),
                      notice: "Bargain successfully deleted." }
      else
        format.html { redirect_to user_bargains_path(current_user),
                      flash: { error: "Cannot delete bargain." }}
      end
    end
  end

  private
    def bargain_params
      params.require(:bargain).permit(:description, :photo)
    end

    def load_user
      User.find(params[:user_id])
    end

end
