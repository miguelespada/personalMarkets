class WishesController < ApplicationController
  load_resource :only => [:show,:edit, :destroy, :update, :recommend]
  authorize_resource :except => [ :list_user_wishes, :gallery, :gallery_user_wishes, :show, :recommend]
  before_filter :load_hidden_tags, only: [:create, :edit, :update]

  def index
    @wishes = Wish.all.desc(:created_at)
    respond_to do |format|
        format.html
        format.json {render json: @wishes}
    end
  end

  def gallery
    @wishes = Wish.all.desc(:created_at).page(params[:page]).per(1)
    render :layout => !request.xhr?
  end

  def gallery_user_wishes
    @wishes = load_user.wishes.all.desc(:created_at).page(params[:page]).per(1)
    render "gallery"
  end

  def list_user_wishes
    @wishes = load_user.wishes.all.desc(:created_at)
    render "index"
  end

  def new
    @wish = Wish.new
    render "form"
  end

  def show
  end

  def recommend
    market = Market.find(params[:market_id])
    @wish.recommend(market)
    redirect_to :back, notice: t(:market_recommended) 
  end 

  def edit
    render "form"
  end

  def create
    @wish = Wish.new(wish_params)
    @wish.user = current_user
    respond_to do |format|
      if @wish.save
        format.html { redirect_to user_wishes_path(current_user), notice: ControllerNotice.success('create', 'wish') }
      else
        format.html { render action: 'new', flash: { error:  ControllerNotice.fail('create', 'wish')  } }
      end
    end
  end

  def update
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to user_wishes_path(current_user), notice: ControllerNotice.success('update', 'wish') }
      else
        format.html { render action: 'edit', flash: { error:  ControllerNotice.fail('update', 'wish') } }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @wish.destroy
        format.html { redirect_to :back, notice: ControllerNotice.success('delete', 'wish') }
      else
        format.html { redirect_to :back, flash: { error: ControllerNotice.fail('delete', 'wish') } }
      end
    end
  end

  private
    def wish_params
      params.require(:wish).permit(:description, :tags, "hidden-wish",   photography_attributes: [:id, :photo])
    end

    def load_user
      User.find(params[:user_id])
    end
    
    def load_hidden_tags
      if params["hidden-wish"].present?
        params[:wish][:tags] = params["hidden-wish"][:tags]
      end
    end

end
