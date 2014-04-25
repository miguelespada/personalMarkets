class UsersDomain

  ["role", "status"].each do |option|
    update_method = "update_" + option
    define_singleton_method update_method do |user_id, new_value|
      user = User.find(user_id)
      user.send(update_method, new_value)
    end
  end

end