require 'quote_util'
require 'open-uri'

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
        "<div class='quote-it clip'>#{clip}</div>"
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
	graph = OpenGraph.new(url)
	if graph then
	  <<END
<div clas='quote-it clip' style="border-radius: 5px 5px 5px 5px; box-shadow: 1px 1px 2px #999999; padding: 10px;">
#{image_tag(graph)}#{title_tag(graph)}#{description_tag(graph)}</div>
END
      end
    end

    def fallback(url)
      image = ThumbnailRule.quote url
      if image then
        "<a class='quote-it thumbnail' href='#{url}' target='_blank'><img src='#{image}' /></a>"
      end
    end

    def image_tag(graph)
      return '' if graph.images.empty?
      return <<-HTML
  <div>
    <a href="#{escapeHTML graph.url}" class="quote-it thumbnail" target="_blank">
      <img src="#{escapeHTML graph.images.first}" style="max-height: 100px" />
    </a>
  </div>
      HTML
    end

    def title_tag(graph)
      if !graph.title.blank?
        return <<-HTML
  <div><a href="#{escapeHTML graph.url}" target="_blank">#{escapeHTML graph.title}</a></div>
        HTML
      elsif graph.images.empty?
        return <<-HTML
  <div><a href="#{escapeHTML graph.url}" target="_blank">#{escapeHTML graph.url}</a></div>
        HTML
      else
        return ''
      end
    end

    def description_tag(graph)
      return '' if graph.description.blank?
      return <<-HTML
  <div>#{escapeHTML graph.description}</div>
      HTML
    end
  end

end
