# -*- coding: utf-8 -*-
require 'wedata_util'
require 'open-uri'

class CleanRoom
  attr_reader :content, :json, :original_url, :clip_url

  @@twitter = Twitter.new

  def initialize(original_url, clip_url)
    @original_url = original_url
    @clip_url     = clip_url

    key = "data::#{clip_url}"
    unless Thumbnailr.cache.get key then
      if @@twitter.include? clip_url then
        Thumbnailr.cache.set key, @@twitter.get(clip_url)
      else
        open(clip_url) do|io|
          Thumbnailr.cache.set key, io.read
        end
      end
    end

    @content = Thumbnailr.cache.get key
    @json    = JSON.parse @content rescue JSON::ParserError
  rescue OpenURI::HTTPError => e
    logger.info e.inspect
    logger.info e.io.meta
    raise e
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
      get(url) || fallback(url)
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
        raise NotMatchError.new
      end
    end

    def fallback(url)
      image = Thumbnail[url]
      if image then
        "<a class='quote-it thumbnail' href='#{url}' target='_blank'><img src='#{image}' /></a>"
      end
    end
  end
end
