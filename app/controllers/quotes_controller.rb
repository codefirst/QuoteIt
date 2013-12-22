class QuotesController < ApplicationController
  def thumbnail
    url = params[:u]
    thumbnail = ThumbnailRule.quote(url)

    unless thumbnail then
      render status: 404, text: '404 Not found'
    else
      respond_to do |format|
        format.json { render json: {
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

  def html
    url = params[:u]
    html = HtmlRule.quote(url)

    unless html then
      render status: 404, text: '404 Not found'
    else
      respond_to do|format|
        format.json { render json: {
          status: 'ok',
          html: html,
          url: url
        } }
        format.html { render text: html }
      end
    end
  end
end
