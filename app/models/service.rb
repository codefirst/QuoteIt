class Service < ActiveRecord::Base
  has_many :html_rules
  has_many :thumbnail_rules

  def thumbnail?
    thumbnail_rules.any?
  end

  def clip?
    html_rules.any?
  end
end
