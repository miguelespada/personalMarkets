class WishesController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:show, :index, :list_user_wishes]
  before_filter :load_hidden_tags, only: [:create, :edit, :update]

  def index
    @wishes = Wish.all
    respond_to do |format|
        format.html
        format.json {render json: @wishes}
    end
  end

  def gallery
    @wishes = Wish.all
    render layout: false
  end

  def list_user_wishes
    @wishes = load_user.wishes.all
    render "index"
  end

  def new
    @wish = Wish.new
  end

  def edit
  end

  def create
    @wish = Wish.new(wish_params)
    @wish.user = current_user
    current_user.wishes << @wish
    respond_to do |format|
      if @wish.save
        format.html { redirect_to user_wishes_path(current_user), notice: 'Wish was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to user_wishes_path(current_user), notice: 'Wish was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @wish.destroy
        format.html { redirect_to user_wishes_url(current_user),
                      notice: "Wish successfully deleted." }
      else
        format.html { redirect_to user_wishes_url(current_user),
                      flash: { error: "Cannot delete wish." }}
      end
    end
  end

  private
    def wish_params
      params.require(:wish).permit(:description, :photo, :tags, "hidden-wish")
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
