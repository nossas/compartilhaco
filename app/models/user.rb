class User < ActiveRecord::Base
  has_one :facebook_profile
end
