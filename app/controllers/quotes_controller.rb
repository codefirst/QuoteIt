class QuotesController < ApplicationController
  before_filter :validate_url

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

  def show
    @url  = params[:u]
    unless Blacklist.include?(@url)
      @thumbnail = ThumbnailRule.quote @url
      @page      = HtmlRule.quote @url
    end
    render status: 404, text: '404 Not found' unless @page
  end

  private
  def validate_url
    unless params[:u] =~ /^#{URI::regexp(%w(http https))}$/
      render status: 404, text: '404 Not found'
    end
  end
end
