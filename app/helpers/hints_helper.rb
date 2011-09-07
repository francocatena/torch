module HintsHelper
  def hint_user_list
    User.all_except(current_user.id).map { |u| [u.to_s, u.id] }
  end
end