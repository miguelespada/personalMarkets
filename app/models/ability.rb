class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    logged_in_abilities

    @user ||= User.new

    if @user.has_role? :admin
      can :manage, :all
    end

  end

  private

  def logged_in_abilities
    if @user
        can :list_user_transactions, User, :id => @user.id

        can [:list_market_transactions, :statistics], Market do |market|
            @user.owns(market)
        end

        # can :archive, Market, :user_id => @user.id
        # can :see_location, Market

        can :publish, Market do |market|
            @user.owns(market) && market.can_be_published
        end

        can :unpublish, Market do |market|
            @user.owns(market) && market.can_be_unpublished
        end
        
        can :manage, Wish do |wish|
            @user.owns(wish)
        end

        can :manage, Photo do |photo|
            @user.owns(photo)
        end

        can :manage, @user

        can :manage, Bargain do |bargain|
            @user.owns(bargain)
        end

        can [:manage, :publish, :archive, :unpublish, :make_pro, :publish_anyway, :quality_section], Market do |market|
            @user.owns(market)
        end 

        can :buy, Coupon
        can :coupon_payment, Coupon
        
        can :show, User, :id => @user.id
        can :statistics, User, :id => @user.id
 
        can :like, Market, Market do |market|
          !@user.owns(market)
        end

        cannot :index, Market
        cannot :index, Wish
        cannot :index, Bargain
        cannot :index, SpecialLocation
        cannot :index, SpecialLocation
        cannot [:force_make_pro], Market

        can :see_localizador, CouponTransaction, CouponTransaction do |transaction|
          @user == transaction.user
        end
    end
  end



end
