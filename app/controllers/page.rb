# -*- coding: utf-8 -*-
require 'webclip/thumbnail'
require 'webclip/html'
require 'json'
Thumbnailr.controllers :page do
  get :thumbnail,:map =>"/thumbnail", :provides => [:json, :jpg, :png, :image, :txt] do
    url = params[:u]
    thumbnail = ::Webclip::Thumbnail[url] || halt(404, 'thumbnail not found')

    case content_type
    when :json
      {
        'status' => 'ok',
        'thumbnail'    => thumbnail,
        'url' => url
      }.to_json
    when :txt
      thumbnail
    when :jpg, :png, :image
      redirect thumbnail
    end
  end

  get :html, :map => '/content', :provides => [:json, :html] do
    url = params[:u]
    content = ::Webclip::Html[url] || halt(404, "page not found")
    case content_type
    when :json
      {
        'status' => 'ok',
        'content'    => content,
        'url' => url
      }.to_json
    else
      content
    end
  end
end
