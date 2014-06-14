class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    logged_in_abilities

    @user ||= User.new

    admin_abilities

  end

  private

  def logged_in_abilities
    if @user
        can :list_user_transactions, User, :id => @user.id

        can [:list_market_transactions, :statistics], Market, Market do |market|
            @user.owns(market)
        end

        # can :archive, Market, :user_id => @user.id
        # can :see_location, Market

        can :publish, Market, Market do |market|
            @user.owns(market) && market.can_be_published
        end

        can :unpublish, Market, Market do |market|
            @user.owns(market) && market.can_be_unpublished
        end
        
        can :manage, Wish, Wish do |wish|
            @user.owns(wish)
        end

        can :manage, Photo, Photo do |photo|
            @user.owns(photo)
        end

        can :manage, Bargain, Bargain do |bargain|
            @user.owns(bargain)
        end

        can [:manage, :publish, :archive, :unpublish, :make_pro, :publish_anyway, :quality_section], Market, Market do |market|
            @user.owns(market)
        end 

        cannot :index, Market

        can :buy, Coupon
        can :coupon_payment, Coupon
        
        can :show, User, :id => @user.id
 
        can :like, Market, Market do |market|
          !@user.owns(market)
        end

        can :list, Market, Market do |market|
          !@user.owns(market) && @user.favorites.include?(market)
        end
    end
  end

  def admin_abilities
    if @user.has_role? :admin
      can [:update], Status
      can [:show, :index, :destroy], User
      can [:change, :update], Role

      can [:list], Coupon
      can :buy, Coupon

      can [:manage], Market
      can [:manage], Wish
      can [:manage], Bargain
      can [:manage], SpecialLocation
      can [:manage], Category
      can [:manage], Tag
      can [:manage], User
      can [:manage], Coupon
      can [:manage], Photo
      can [:manage], Gallery
      can [:list_user_transactions], User
      can [:list_market_transactions], Market

    end
  end

end
