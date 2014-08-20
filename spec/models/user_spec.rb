require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_one :facebook_profile }
  it { should have_one :twitter_profile }
end
