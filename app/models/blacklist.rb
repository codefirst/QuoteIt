class Blacklist
  DEFAULT_LIST = ['localhost', '127.0.0.1']

  def self.include?(url)
    additional_list = (ENV['BLACKLIST'] || '').split
    uri = Addressable::URI.parse(url)
    (DEFAULT_LIST + additional_list).include?(uri.host)
  end
end

