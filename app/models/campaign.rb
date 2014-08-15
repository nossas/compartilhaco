class Campaign < ActiveRecord::Base
  has_many :campaign_spreaders

  mount_uploader :image, ImageUploader
end
