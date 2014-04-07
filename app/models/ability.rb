class Ability
  include CanCan::Ability

  def initialize(user)

    if user
        can :comment, Market
        can :see_location, Market
        can :report, Comment
        can :like, Market, Market do |market|
            user.can_like market
        end
        can :unlike, Market, Market do |market|
            user.can_unlike market
        end
    end

    user ||= User.new

    if user.has_role? :admin
      can [:edit, :update], Comment
      can :destroy, Comment
      can :edit, Market
    end

    if user.has_role? :moderator
      can :destroy, Comment

      can :delete_image, Market, Market do |market|
        market.featured?
      end
    else
      can :destroy, Comment, :author => user.email
    end

    can [:edit, :update], Comment, :author => user.email
    can :edit, Market, :user_id => user.id
    can :delete, Market, :user_id => user.id
  end
end
