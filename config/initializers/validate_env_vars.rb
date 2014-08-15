if Rails.env.production?
  raise "ACCOUNTS_HOST is not defined" if ENV["ACCOUNTS_HOST"].nil?
  raise "ACCOUNTS_API_TOKEN is not defined" if ENV["ACCOUNTS_API_TOKEN"].nil?
end
