CarrierWave.configure do |config|
  if Rails.env.development? or Rails.env.test?
    config.storage = :file
    config.enable_processing = Rails.env.development?
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV["AWS_ID"],
      :aws_secret_access_key  => ENV["AWS_SECRET"],
    }
    config.fog_directory  = ENV["AWS_BUCKET"]
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
    config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku
  end
end