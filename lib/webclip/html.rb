# -*- coding: utf-8 -*-
require 'open-uri'
require 'json'
require 'webclip/webclip'


module Webclip
  class Html < ::Webclip::Webclip
    def self.[](url)
      best_match(url)
    end

    rule /https?:\/\/twitter\.com\/(?:#!\/)?[a-zA-Z0-9_]+\/status(?:es)?\/([0-9]+)/ do|id|
      open("http://api.twitter.com/1/statuses/show.json?id=#{id}") do|io|
        json = JSON.parse io.read
<<HTML
<div class="twitter content">
  <div class="info" stlye="margin-top:3px;margin-bottom:3px;">
    <a style="float:left" class="user-icon" href='http://twitter.com/#{json['user']['screen_name']}'>
      <img style="-moz-box-shadow: 1px 1px 2px #999;-webkit-box-shadow: 1px 1px 2px #999;-moz-border-radius: 2px 2px 2px 2px;-webkit-border-radius: 2px 2px 2px 2px;height:2.5em;margin-right:5px;" src='#{json['user']['profile_image_url']}'/>
    </a>
    <span class='user-name' style="font-weight:bold">#{json['user']['name']}</span>
    <div class="created-at" stlye="margin-bottom: 3px;">#{json['created_at']}</div>
  </div>
  <div class='content' style="clear:both;padding:0 5px">#{json['text']}</div>
</div>
HTML
      end
    end
  end
end

