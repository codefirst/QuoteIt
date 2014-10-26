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
    begin
      html = HtmlRule.quote(url)
    rescue OpenURI::HTTPError => e
      Rails.logger.error "#{e.message}: #{url}"
      status = e.message.split.first.to_i rescue 404
      render status: status, text: e.message
      return
    end

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
    @thumbnail = ThumbnailRule.quote @url
    @page      = HtmlRule.quote @url
    render status: 404, text: '404 Not found' unless @page
  end

  private
  def validate_url
    if (not url?(params[:u])) or Blacklist.include?(params[:u])
      render status: 404, text: '404 Not found'
    end
  end

  def url?(url)
    return false unless url =~ /^((https?):\/\/[^\s]+)$/
    return false if url =~ /^https?:\/\/$/ # only 'http://'
    true
  end
end
