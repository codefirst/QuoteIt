class Thumbnail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :url
  field :regexp
  field :thumbnail
  field :source

  class << self
    def update!(items)
      self.where(:source => 'wedata').delete_all
      items.each do|item|
        data = item['data']
        self.create(:name => item['name'],
                    :regexp => data['regexp'],
                    :thumbnail => data['thumbnail'],
                    :url => data['url'],
                    :source => 'wedata',
                    :updated_at => Time.parse(item['updated_at']))
      end
    end

    def status(item)
      x = self.first(:conditions => {:name => item['name']})
      case
      when x == nil
        :new
      when x.updated_at < Time.parse(item['updated_at'])
        :updated
      else
        :exist
      end
    end

    def [](url)
      item = self.where.to_a.find do|x|
        url =~ /#{x.regexp}/
      end
      if item then
        match = Regexp.new(item.regexp).match(url)
        thumbnail = item.thumbnail
        match.captures.each_with_index do|capture,i|
          thumbnail.gsub!("$#{i+1}", capture)
        end
        thumbnail
      end
    end
  end
end
