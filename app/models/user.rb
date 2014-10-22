class User < ActiveRecord::Base
  acts_as_our_cities_user

  has_one :facebook_profile
  has_one :twitter_profile
  has_many :spam_reports
end
