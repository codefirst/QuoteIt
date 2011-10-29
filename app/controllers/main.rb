Thumbnailr.controllers do
  get '/' do
    render 'main/index'
  end

  get :show, :map => '/show' do
    @url  = params[:u]
    @thumbnail = Thumbnail[@url]
    @page      = Html[@url]
    halt(404, "page not found") unless @page
    render 'main/show'
  end

  get :services, :map=>'/plugins' do
    @thumbnails = ::Thumbnail.all.to_a.sort_by{|x| x.name.downcase }
    @htmls      = ::Html.all.to_a.sort_by{|x| x.name.downcase }
    @title = 'Plugins'
    render 'main/plugins'
  end

  get :about, :map => '/about' do
    render 'main/about'
  end
end
