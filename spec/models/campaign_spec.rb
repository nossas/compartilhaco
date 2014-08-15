require 'rails_helper'

RSpec.describe Campaign, :type => :model do
  it { should have_many :campaign_spreaders }
end
