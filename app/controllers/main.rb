require 'webclip/html'
Thumbnailr.controllers do
  get '/' do
    render 'main/index'
  end

  get :show, :map => '/show' do
    @url  = params[:u]
    @thumbnail = Thumbnail[@url]
    @page      = Html[@url]
    render 'main/show'
  end

  get :services, :map=>'/services' do
    sort = lambda do|xs|
      xs.select{|x| x[:service] != nil }.sort_by{|x| x[:service].downcase }
    end

    @thumbnails = ::Thumbnail.all.to_a.sort_by{|x| x.name.downcase }
    @htmls      = sort[::Webclip::Html.all_rules]
    render 'main/services'
  end
end
