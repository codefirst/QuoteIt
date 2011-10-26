Thumbnailr.controllers :wedata do
  get :index, :map => '/wedata' do
    open('http://wedata.net/databases/QuoteIt-thumbnail/items.json') do|io|
      @thumbnails = JSON.parse(io.read).map{|item|
        item['status'] = Thumbnail.status item
        item
      }
    end
    render 'wedata/index'
  end

  post :update, :map => '/wedata/update' do
    open('http://wedata.net/databases/QuoteIt-thumbnail/items.json') do|io|
      items = JSON.parse(io.read)
      count = Thumbnail.update! items
      flash[:notice] = "Updated #{items.size} items"
    end
    redirect url_for(:wedata_index)
  end
end
