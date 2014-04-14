class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    logged_in_abilities

    @user ||= User.new

    admin_abilities
    moderator_abilities

    can [:edit, :update], Comment, :author => @user.email
    can [:edit, :update], Market, :user_id => @user.id
    can :delete, Market, :user_id => @user.id
  end


  private

  def logged_in_abilities
    if @user
        can :comment, Market
        can :buy_coupon, Market
        can :see_location, Market
        can :report, Comment
        can :like, Market, Market do |market|
            @user.can_like market
        end
        can :unlike, Market, Market do |market|
            @user.can_unlike market
        end

    end
  end

  def admin_abilities
    if @user.has_role? :admin
      can [:edit, :update], Comment
      can :destroy, Comment
      can [:edit, :update], Market
      can [:list], CouponTransaction
    end
  end

  def moderator_abilities
    if @user.has_role? :moderator
      can :destroy, Comment

      can :delete_image, Market, Market do |market|
        market.featured?
      end
    else
      can :destroy, Comment, :author => @user.email
    end
  end
end
