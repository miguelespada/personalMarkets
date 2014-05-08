class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    logged_in_abilities

    @user ||= User.new

    admin_abilities

    can [:edit, :update], Comment, :author => @user.email
    can [:edit, :update], Market, :user_id => @user.id
    can :delete, Market, :user_id => @user.id
  end

  private

  def logged_in_abilities
    if @user
        can :archive, Market, :user_id => @user.id
        can :see_location, Market
        can :report, Comment

        can :publish, Market, Market do |market|
            @user.owns(market) && market.can_be_published
        end

        can :unpublish, Market, Market do |market|
            @user.owns(market) && market.can_be_unpublished
        end

        can :destroy, Comment, :author => @user.email
        
        can :manage, Wish, Wish do |wish|
            @user.owns(wish)
        end
        can :manage, Bargain, Bargain do |bargain|
            @user.owns(bargain)
        end

        can :buy, Coupon
        can :coupon_payment, Coupon

        can :show, User, :user_id => @user.id
        
        can :like, Market, Market do |market|
          !@user.owns(market) && !@user.favorites.include?(market)
        end

        can :unlike, Market, Market do |market|
          !@user.owns(market) && @user.favorites.include?(market)
        end
    end
  end

  def admin_abilities
    if @user.has_role? :admin
      can [:update], Status
      can [:show, :index, :destroy], User
      can [:change, :update], Role
      can :archive, Market
      can :delete_image, Market
      can [:edit, :update], Comment
      can :destroy, Comment
      can [:edit, :update], Market
      can [:list], Coupon
      can :buy, Coupon

      can [:manage], Wish
      can [:manage], Bargain
      can [:manage], SpecialLocation
      can [:manage], Category
      can [:manage], Tag
      can [:manage], User

    end
  end

end
