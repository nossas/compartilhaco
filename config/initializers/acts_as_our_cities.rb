ActsAsOurCities.config do |config|
  config.api_mode = true
  config.api_site = ENV["ACCOUNTS_API_URL"]
  config.api_token = ENV["ACCOUNTS_API_TOKEN"]
end
