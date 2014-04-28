class WishesController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:show, :index, :list_user_wishes]

  def index
    @wishes = Wish.all
    render :layout => !request.xhr?
  end

  def list_user_wishes
    @wishes = load_user.wishes.all
    render "index"
  end

  def show
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
        format.html { redirect_to @wish, notice: 'Wish was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to @wish, notice: 'Wish was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @wish.destroy
    respond_to do |format|
      format.html { redirect_to user_wishes_url(current_user) }
    end
  end

  private
    def wish_params
      params.require(:wish).permit(:description, :wish_photo)
    end

    def load_user
      User.find(params[:user_id])
    end

end
