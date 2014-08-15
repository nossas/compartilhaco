class Timeline < ActiveRecord::Base
  self.abstract_class = true
  has_many :campaign_spreaders
end
