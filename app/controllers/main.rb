require 'webclip/html'
require 'webclip/thumbnail'
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

  get :services, :map=>'/services' do
    sort = lambda do|xs|
      xs.select{|x| x[:service] != nil }.sort_by{|x| x[:service].downcase }
    end

    @thumbnails = sort[::Webclip::Thumbnail.all_rules]
    @htmls      = sort[::Webclip::Html.all_rules]
    render 'main/services'
  end
end
