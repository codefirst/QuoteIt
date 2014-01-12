class SandboxController < ApplicationController
  def index
    @content = 'content'
  end

  def thumbnail
    @thumbnail = ThumbnailRule.run_rule(
      params[:url],
      regexp:    params[:regexp].to_s.strip,
      thumbnail: params[:thumbnail].to_s.strip)
    render layout: false
  rescue => e
    render text: "ERROR: #{e}"
  end

  def html
    @webClip = HtmlRule.run_rule(
      params[:url],
      regexp: params[:regexp].to_s.strip,
      clip:   params[:clip].to_s.strip,
      transform: params[:transform].to_s.strip)
    render layout: false
  rescue => e
    render text: "ERROR: #{e}"
  end
end
