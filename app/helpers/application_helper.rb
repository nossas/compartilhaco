module ApplicationHelper
  def user_path user
    "#{ENV['MEURIO_HOST']}/users/#{user.id}"
  end
end
