class BargainsController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:show, :list_user_bargains, :gallery_user_bargains, :gallery]

  def index
    @bargains = Bargain.all.desc(:created_at)
    respond_to do |format|
        format.html
        format.json {render json: @bargains}
    end
  end

  def gallery
    @bargains = Bargain.all.desc(:created_at).page(params[:page]).per(1)
    render :layout => !request.xhr?
  end

  def gallery_user_bargains
    @bargains = load_user.bargains.all.desc(:created_at).page(params[:page]).per(1)
    render "gallery"
  end

  def list_user_bargains
    @bargains = load_user.bargains.all.desc(:created_at)
    render "index"
  end

  def new
    if !current_user.too_many_bargains?
      @bargain = Bargain.new
    end
    render "form"
  end

  def show
  end

  def edit
    render "form"
  end

  def create
    @bargain = Bargain.new(bargain_params)
    @bargain.user = current_user
    respond_to do |format|
      if @bargain.save
        format.html { redirect_to user_bargains_path(current_user), notice: ControllerNotice.success('created', 'bargain')  }
      else
        format.html { redirect_to user_bargains_path(current_user), flash: { error:  ControllerNotice.fail('created', 'bargain') }}
      end
    end
  end

  def update
    respond_to do |format|
      if @bargain.update(bargain_params)
        format.html { redirect_to user_bargains_path(current_user), notice: ControllerNotice.success('updated', 'bargain')  }
      else
        format.html { redirect_to user_bargains_path(current_user), flash: { error:  ControllerNotice.fail('updated', 'bargain') }}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @bargain.destroy
        format.html { redirect_to user_bargains_path(current_user),
                      notice: ControllerNotice.success('deleted', 'bargain')  }
      else
        format.html { redirect_to user_bargains_path(current_user),
                      flash: { error:  ControllerNotice.fail('deleted', 'bargain')}}
      end
    end
  end

  private
    def bargain_params
      params.require(:bargain).permit(:description, :price, photography_attributes: [:photo])
    end

    def load_user
      User.find(params[:user_id])
    end

end
