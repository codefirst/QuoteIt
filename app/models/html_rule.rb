require 'quote_util'
require 'open-uri'
require 'opengraph'

class CleanRoom
  attr_reader :content, :json, :original_url, :clip_url

  def initialize(original_url, clip_url)
    @original_url = original_url
    @clip_url     = clip_url

    return if clip_url.blank?

    @content = open(clip_url).read
    @json    = JSON.parse @content rescue JSON::ParserError
  rescue OpenURI::HTTPError => e
    Rails.logger.info e.inspect
    Rails.logger.info e.io.meta
    raise e
  end
end


class HtmlRule < ActiveRecord::Base
  belongs_to :service

  class NotMatchError < StandardError; end

  class << self
    include QuoteUtil
    def quote(url)
      get(url)       ||
      fallback(url)  ||
      opengraph(url)
    end

    def get(url)
      item = all.find do|x|
        url =~ /#{x.regexp}/
      end
      if item then
        run_rule url, regexp: item.regexp, clip: item.clip, transform: item.transform
      end
    end

    def run_rule(url, rule)
      if url =~ /#{rule[:regexp]}/ then
        clip = eval_regexp url, rule[:regexp], rule[:clip]
        if rule[:transform] and not rule[:transform].empty? then
          CleanRoom.new(url, clip).instance_eval do
            proc {
              clip = eval rule[:transform]
            }.call
          end
        end
        "<div clas='quote-it clip'>#{clip}</div>"
      else
        raise NotMatchError.new
      end
    end

    def escapeHTML(s)
      if s then
        CGI.escapeHTML s
      end
    end

    def opengraph(url)
	graph = OpenGraph.fetch url
	if graph then
	  <<END
<div clas='quote-it clip' style="border-radius: 5px 5px 5px 5px; box-shadow: 1px 1px 2px #999999; padding: 10px;">
  <div>
    <a href="#{escapeHTML graph.url}" class="quote-it thumbnail" target="_blank">
      <img src="#{escapeHTML graph.image}" style="max-height: 100px" />
    </a>
  </div>
  <div><a href="#{escapeHTML graph.url}" target="_blank">#{escapeHTML graph.title}</a></div>
  <div>#{escapeHTML graph.description}</div>
</div>
END
	end
    end

    def fallback(url)
      image = ThumbnailRule.quote url
      if image then
        "<a class='quote-it thumbnail' href='#{url}' target='_blank'><img src='#{image}' /></a>"
      end
    end
  end

end
