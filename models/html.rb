require 'webclip/html'

class Html
  class << self
    def [](url)
      ::Webclip::Html[url] || fallback(url)
    end

    def fallback(url)
      image = Thumbnail[url]
      if image then
        "<a href='#{url}'><img src='#{image}' /></a>"
      end
    end
  end
end
