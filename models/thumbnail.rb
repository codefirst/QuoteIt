require 'wedata_util'

class Thumbnail
  include Mongoid::Document
  include Mongoid::Timestamps
  extend WedataUtil

  field :name
  field :url
  field :regexp
  field :thumbnail
  field :source

  class << self
    def update!(items)
      update_by!(items) do|data|
        {
          :regexp => data['regexp'],
          :thumbnail => data['thumbnail'],
          :url => data['url'],
        }
      end
    end

    def [](url)
      item = self.where.to_a.find do|x|
        url =~ /#{x.regexp}/
      end
      if item then
        eval_regexp url, item.regexp, item.thumbnail
      end
    end
  end
end
