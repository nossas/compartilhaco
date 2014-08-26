CarrierWave.configure do |config|
  if Rails.env.development? or Rails.env.test?
    config.storage = :file
    config.enable_processing = Rails.env.development?
  else
    config.storage    = :aws
    config.aws_bucket = ENV['AWS_BUCKET']
    config.aws_acl    = :public_read
    config.aws_credentials = {
      access_key_id:     ENV['AWS_ID'],
      secret_access_key: ENV['AWS_SECRET']
    }
  end
end
