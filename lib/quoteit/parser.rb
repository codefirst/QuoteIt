require 'json'

module Quoteit
  class Parser
    class <<self
      def service(s)
          xs = Service.where(name: s['name'])
          if xs.any? then
            xs.first.tap{|x| x.update_attributes(s) }
          else
            Service.new(s)
          end
      end

      def thumbnail(t)
        t = t.merge(service: service(t['service']))
        xs = ThumbnailRule.where(regexp: t['regexp'])
        if xs.any? then
          xs.first.tap{|x| x.update_attributes(t) }
        else
          ThumbnailRule.new(t)
        end
      end

      def html(h)
        h = h.merge(service: service(h['service']))
        xs = HtmlRule.where(regexp: h['regexp'])
        if xs.any? then
          xs.first.tap{|x| x.update_attributes(h) }
        else
          HtmlRule.new(h)
        end

      end

      private :service, :thumbnail, :html

      def load(config)
        {
          thumbnails: config['thumbnails'].to_a.map(&method(:thumbnail)),
          htmls:      config['htmls'].to_a.map(&method(:html))
        }
      end

      def load_from_file(path)
        self.load JSON.parse(File.read(path))
      end
    end
  end
end
