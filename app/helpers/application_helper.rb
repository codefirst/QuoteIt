module ApplicationHelper
    def url_link(url)
      root = request.scheme + '://' + request.host
      root += ":#{request.port}" unless request.port == 80
      link_to root+url, url
    end
end
