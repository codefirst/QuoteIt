ActiveSupport.on_load(:active_record) do
  require 'quoteit/parser'

  x = Quoteit::Parser.load_from_file(Rails.root + './config/quote_it.json')
  x[:thumbnails].each(&:save!)
  x[:htmls].each(&:save!)
end
