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

  get :services, :map=>'/services' do
    @thumbnails = ::Thumbnail.all.to_a.sort_by{|x| x.name.downcase }
    @htmls      = ::Html.all.to_a.sort_by{|x| x.name.downcase }
    render 'main/services'
  end
end
