if Rails.env.test?
  ENV["CAS_SERVER_URL"] = "/minhascidades_accounts"
  ENV["TECH_TEAM_EMAIL"] = "tech@minhascidades.org.br"
end
