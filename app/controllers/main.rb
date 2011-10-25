require 'webclip/html'
Thumbnailr.controllers do
  get '/' do
    render 'main/index'
  end

  get :show, :map => '/show' do
    @url  = params[:u]
    @thumbnail = ::Webclip::Thumbnail[@url]
    @page = ::Webclip::Html[@url]
    @root = request.scheme + '://' + request.host
    @root += ":#{request.port}" unless request.port == 80
    render 'main/show'
  end
end
