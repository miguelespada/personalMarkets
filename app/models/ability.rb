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
        can :like, Market, Market do |market|
            @user.can_like market
        end
        can :unlike, Market, Market do |market|
            @user.can_unlike market
        end
        can :publish, Market, Market do |market|
            @user.owns(market) && market.can_be_published
        end

        can :destroy, Comment, :author => @user.email
        

        can :manage, Wish, Wish do |wish|
            @user.owns(wish)
        end

        can :buy, Coupon
        can :list_transactions, Coupon

        can :show, User, :user_id => @user.id
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
      can :see_transactions, User
      can [:manage], Wish
      can [:manage], SpecialLocation
      can [:manage], Category
      can [:manage], Tag

      can :buy, Coupon
      can :list_transactions, Coupon
    end
  end

end
