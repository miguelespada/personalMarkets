class UsersController < ApplicationController
  load_resource :only => [:show, :destroy, :edit, :update, :user_dashboard, :subscription_plan, :subscription]
  authorize_resource :only => [:index, :destroy, :edit, :update]  
 
  def index
    @users =  User.all.asc(:email).page(params[:page]).per(12)
  end
  
  def gallery
    @users = User.all.desc(:nickname).page(params[:page]).per(6)
  end

  def users_who_like_market
    @users = Market.find(params[:market_id]).favorited.page(params[:page]).per(6)
    render "gallery"
  end

  def show
  end

  def edit
    render 'form'
  end

  def live_search
    @per_page = params[:per_age].present? ? params[:per_page].to_i : 6
    @page = params[:page].present? ? params[:page].to_i : 1
    @result = User.search(params, @page, @per_page)
    @last_page = @result[:total]/@per_page.to_f <= @page 
    @first_page = @page == 1
    @users = @result[:users]
    if !request.xhr? == false
      render partial: "users/views/live_gallery", :layout => false
    else
      render "live_search"
    end 
  end 


  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path, notice: ControllerNotice.success('updated', 'user')}
      else
        format.html { render action: 'edit' }
      end
    end
  end


  def like
    market = Market.find(params[:market_id])
    raise CanCan::AccessDenied if cannot? :like, market
    current_user.like(market)
    redirect_to :back
  end

  def unlike
    market = Market.find(params[:market_id])
    raise CanCan::AccessDenied if cannot?(:like, market) || !current_user.favorites.include?(market)
    current_user.unlike(market)
    redirect_to :back
  end

  def follow
    user = User.find(params[:user_id])
    current_user.follow(user) if current_user != user
    redirect_to :back
  end

  def unfollow
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to :back
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: ControllerNotice.success('deleted', 'user')
    else
      redirect_to users_path, flash: { error: ControllerNotice.fail('deleted', 'user') }
    end
  end

  def subscription_plan
    authorize! :manage, @user
  end

  def subscription
    authorize! :manage, @user
    payment = Payment.new ENV['PREMIUM_PRICE'].to_f, 1
    @subscription_payment = SubscriptionPayment.new payment
    render "subscription_payment_form"
  end

  def admin
    authorize! :manage, :all
    render "users/dashboards/admin_panel"
  end

  def user_dashboard
    authorize! :manage, @user
    render "users/dashboards/user_panel"
  end
   private
    def user_params
      params.require(:user).permit(:nickname, :description, featured_attributes: [:photo])
    end
end
