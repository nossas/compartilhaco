class User < ActiveRecord::Base
  has_one :facebook_profile
  has_one :twitter_profile

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
end
