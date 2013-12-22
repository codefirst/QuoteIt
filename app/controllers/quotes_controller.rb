class QuotesController < ApplicationController
  def thumbnail
    url = params[:u]
    thumbnail = ThumbnailRule.quote(url)

    unless thumbnail then
      render status: 404, nothing: true
    else
      respond_to do |format|
        format.json { render :json => {
          status: 'ok',
          thumbnail: thumbnail,
          url: url
        } }
        format.text { render text: thumbnail }
        format.jpeg { redirect_to thumbnail }
        format.png { redirect_to thumbnail }
      end
    end
  end
end
