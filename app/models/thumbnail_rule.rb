require 'quote_util'

class ThumbnailRule < ActiveRecord::Base
  belongs_to :service

  class NotMatchError < StandardError; end

  class << self
    include QuoteUtil
    def quote(url)
      item = self.all.find do|x|
        url =~ /#{x.regexp}/
      end
      if item then
        run_rule url, regexp: item.regexp, thumbnail: item.thumbnail
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
