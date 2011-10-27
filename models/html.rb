# -*- coding: utf-8 -*-
require 'wedata_util'

class CleanRoom
  attr_reader :content, :json
  def initialize(url)
    key = "data::#{url}"
    unless Thumbnailr.cache.get key then
      open(url) do|io|
        Thumbnailr.cache.set key, io.read
      end
    end

    @content = Thumbnailr.cache.get key
    @json    = JSON.parse @content
  rescue => e
    logger.info e.inspect
    logger.info e.io.meta
    raise e
  end
end

class Html
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
      logger.info "get for #{url}"
      item = self.where.to_a.find do|x|
        url =~ /#{x.regexp}/
      end
      if item then
        clip = WedataUtil::eval_regexp url, item.regexp, item.clip
        if item.transform then
          CleanRoom.new(clip).instance_eval do
            proc {
              $SAFE = 4
              clip = eval item.transform
            }.call
          end
        end
        "<div clas='quote-it clip'>#{clip}</div>"
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
