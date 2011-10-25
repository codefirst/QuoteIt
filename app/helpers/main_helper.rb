# Helper methods defined here can be accessed in any controller or view in the application

Thumbnailr.helpers do
  def url_link(url)
    link_to url, url
  end
end
