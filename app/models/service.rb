class Service < ActiveRecord::Base
  has_many :html_rules
  has_many :thumbnail_rules
end
