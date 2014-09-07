require 'roles'

class UsersPresenter

  def self.for users
    new users
  end

  def initialize users
    @users = users
  end

  def grouped_by_role
    Roles.all.each do |role|
      yield role, with_role(role)
    end
  end

  def with_role role
    @users.select do |user| 
      user.role == role
    end
  end

end