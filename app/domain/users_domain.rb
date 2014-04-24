class UsersDomain

  def self.desactivate user_id
    User.find(user_id).desactivate
  end

  def self.update_role user_id, new_role
    User.find(user_id).update_role(new_role)
  end

end