class UsersDomain

  ["desactivate", "activate"].each do |status_change|
    define_singleton_method status_change do |user_id|
      User.find(user_id).send status_change
    end
  end

  def self.update_role user_id, new_role
    user = User.find(user_id)
    user.update_role new_role
  end

end