require 'wedata_util'

class CleanRoom
  attr_reader :content, :json
  def initialize(url)
    open(url) do|io|
      @content = io.read
      @json    = JSON.parse @content
    end
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
