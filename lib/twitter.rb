# -*- coding: utf-8 -*-
require 'oauth'
require 'oauth-patch'
require 'json'

class Twitter
  def initialize
    @consumer_key    = ENV['CONSUMER_KEY']
    @consumer_secret = ENV['CONSUMER_SECRET']
    @access_token    = ENV['ACCESS_TOKEN']
    @access_token_secret = ENV['ACCESS_TOKEN_SECRET']

    if @consumer_key and @consumer_secret and @access_token and @access_token_secret then
      @consumer = OAuth::Consumer.new(@consumer_key,
                                      @consumer_secret,
                                      :site => 'http://twitter.com')
      @access_token = OAuth::AccessToken.new(@consumer,
                                             @access_token,
                                             @access_token_secret)
    end
  end

  def get(url)
    @access_token.get(url).body
  end

  def include?(url)
    @access_token and url =~ %r!https?://(.*)\.twitter\.com/!
  end
end

