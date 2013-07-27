# -*- coding: utf-8 -*-
require 'wedata_util'
require 'open-uri'
require 'cgi'

class CleanRoom
  attr_reader :content, :json, :original_url, :clip_url

  def initialize(original_url, clip_url)
    @original_url = original_url
    @clip_url     = clip_url

    return if clip_url.blank?

    key = "data::#{clip_url}"
    unless Thumbnailr.cache.get encode(key) then
      open(clip_url) do|io|
        Thumbnailr.cache.set encode(key), io.read
      end
    end

    @content = Thumbnailr.cache.get encode(key)
    @json    = JSON.parse @content rescue JSON::ParserError
  rescue OpenURI::HTTPError => e
    logger.info e.inspect
    logger.info e.io.meta
    raise e
  end

  private
  def encode(key)
    Digest::SHA1.hexdigest(key)
  end
end

class Html
  class NotMatchError < StandardError; end

  include Mongoid::Document
  include Mongoid::Timestamps
  extend WedataUtil

  field :name
  field :url
  field :regexp
  field :clip
  field :transform

  class << self
    def update!(items)
      update_by!(items) do|data|
        {
          :regexp    => data['regexp'],
          :clip      => data['clip'],
          :transform => data['transform'],
          :url       => data['url']
        }
      end
    end

    def [](url)
      key = Digest::SHA1.hexdigest("result:#{url}")
      html = Thumbnailr.cache.get key
      unless html then
        html = get(url) || opengraph(url) || fallback(html)

        if html then
          Thumbnailr.cache.set key, html
        end
      end

      html
    end

    def get(url)
      item = self.where.to_a.find do|x|
        url =~ /#{x.regexp}/
      end
      if item then
        run_rule url, :regexp=>item.regexp, :clip=>item.clip, :transform => item.transform
      end
    end

    def run_rule(url, rule)
      if url =~ /#{rule[:regexp]}/ then
        clip = eval_regexp url, rule[:regexp], rule[:clip]
        if rule[:transform] and not rule[:transform].empty? then
          CleanRoom.new(url, clip).instance_eval do
            proc {
              $SAFE = 4
              clip = eval rule[:transform]
            }.call
          end
        end
        "<div clas='quote-it clip'>#{clip}</div>"
      else
        nil
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
    rescue
      nil
    end


    def fallback(url)
      image = Thumbnail[url]
      if image then
        "<a class='quote-it thumbnail' href='#{url}' target='_blank'><img src='#{image}' /></a>"
      end
    end
  end
end
