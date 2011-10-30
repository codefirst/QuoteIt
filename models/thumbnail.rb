require 'wedata_util'

class Thumbnail
  class NotMatchError < StandardError; end
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
        run_rule url, :regexp => item.regexp, :thumbnail => item.thumbnail
      end
    end

    def run_rule(url, rule)
      if url =~ /#{rule[:regexp]}/ then
        eval_regexp url, rule[:regexp], rule[:thumbnail]
      else
        raise NotMatchError.new
      end
    end
  end
end
