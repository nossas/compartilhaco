require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_one :facebook_profile }
end
