class User < ActiveRecord::Base
  has_one :facebook_profile
  has_one :twitter_profile
  has_many :spam_reports

  # TODO: move this method to a gem
  def self.create params
    if Rails.env.production? || Rails.env.staging?
      begin
        url = "#{ENV["ACCOUNTS_HOST"]}/users.json"

        user_hash = {
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email],
          password: SecureRandom.hex,
          ip: params[:ip]
        }

        body = { token: ENV["ACCOUNTS_API_TOKEN"], user: user_hash }
        response = HTTParty.post(url, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
        User.find_by_id(response['id'])
      rescue Exception => e
        logger.error e.message
      end
    else
      super
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def avatar_url
    if self.avatar
      "https://#{ENV['ACCOUNTS_BUCKET']}.s3.amazonaws.com/uploads/user/avatar/#{self.id}/square_#{self.avatar}"
    else
      "http://i.imgur.com/7XqAySb.png"
    end
  end
end
