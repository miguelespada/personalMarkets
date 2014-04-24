class UsersDomain

  ["desactivate", "activate"].each do |status_change|
    define_singleton_method status_change do |user_id|
      User.find(user_id).send status_change
    end
  end

  ["role", "status"].each do |option|
    update_method = "update_" + option
    define_singleton_method update_method do |user_id, new_value|
      user = User.find(user_id)
      user.send(update_method, new_value)
    end
  end

end