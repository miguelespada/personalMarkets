class WishesController < ApplicationController
  before_action :load_wish, only: [:show, :edit, :update, :destroy]
  before_filter :load_user

  def index
    if @user
      @wishes = @user.wishes.all
    else
      @wishes = Wish.all
    end
  end

  def show
  end

  def new
    @wish = Wish.new
  end

  def edit
    authorize! :edit, @wish
    rescue CanCan::AccessDenied
      render :status => 401, :text => "Unauthorized action"
  end

  def create
    @wish = Wish.new(wish_params)
    @wish.user = @user
    @user.wishes << @wish
    respond_to do |format|
      if @wish.save
        format.html { redirect_to user_wishes_path(@user, @wish), notice: 'Wish was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    authorize! :edit, @wish
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to user_wish_path(@user, @wish), notice: 'Wish was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end

    rescue CanCan::AccessDenied
      render :status => 401, :text => "Unauthorized action"
  end

  def destroy
    authorize! :edit, @wish
    @wish.destroy
    respond_to do |format|
      format.html { redirect_to user_wishes_url(@user) }
    end
    rescue CanCan::AccessDenied
      render :status => 401, :text => "Unauthorized action"
  end

  private
    def load_wish
      @wish = Wish.find(params[:id])
    end

    def wish_params
      params.require(:wish).permit(:description, :user_id, :wish_photo)
    end

    def load_user
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      end 
    end
end
