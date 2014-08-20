class Campaign < ActiveRecord::Base
  has_many :campaign_spreaders
  mount_uploader :image, ImageUploader

  scope :unshared, -> { where("shared_at IS NULL") }

  def share
    campaign_spreaders.each {|cs| cs.share}
    update_attribute :shared_at, Time.now
  end
end
