if Rails.env.test?
  ENV["CAS_SERVER_URL"] = "/minhascidades_accounts"
end