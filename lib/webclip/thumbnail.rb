require 'webclip/webclip'

module Webclip
  class Thumbnail < ::Webclip::Webclip
    def self.[](url)
      best_match(url)
    end

    rule_reset!

    rule /twitpic\.com\/([A-z0-9]+)/ do|conf|
      conf.field :service, 'twitpic'
      conf.field :url,     'http://twitpic.com'

      conf.on do |r1|
        unless r1 == "photos" then
          'http://twitpic.com/show/thumb/'+r1
        end
      end
    end

    rule /(f\.hatena\.ne\.jp\/(([^\/])[^\/]+)\/(([0-9]{8})[0-9]+))/i do|conf|
      conf.field :service, 'Hatena fotolife'
      conf.field :url,     'http://f.hatena.ne.jp/'

      conf.on do|r1,r2,r3,r4,r5|
        'http://img.f.hatena.ne.jp/images/fotolife/'+r3+'/'+r2+'/'+r5+'/'+r4+'_120.jpg'
      end
    end

    rule /movapic\.com\/pic\/([\d\w]+)/i do|conf|
      conf.field :service, 'movapic'
      conf.field :url,     'http://movapic.com'

      conf.on do|r1|
        'http://image.movapic.com/pic/s_'+r1+'.jpeg'
      end
    end

    rule /yfrog.com\/([\d\w]+)/i do|conf|
      conf.field :service, 'yfrog'
      conf.field :url,     'http://yfrog.com'

      conf.on do|r1|
         'http://yfrog.com/'+r1+'.th.jpg'
      end
    end

    rule /ow.ly\/i\/([\d\w]+)/i do|conf|
      conf.field :service, 'ow.ly'
      conf.field :url, 'http://ow.ly'

      conf.on do|r1|
         'http://static.ow.ly/photos/thumb/'+r1+'.jpg'
      end
    end

    rule /(?:youtu\.be\/|www\.youtube\.com\/watch\?v\=)([\d\-\w]+)/i do|conf|
      conf.field :service,'YouTube'
      conf.field :url,'http://youtube.com'

      conf.on do|r1|
        'http://i.ytimg.com/vi/'+r1+"/hqdefault.jpg"
      end
    end

    rule /www\.nicovideo\.jp\/watch\/(?:[a-z]*?)([\d]+)\??/i do|conf|
      conf.field :service, 'NicoVideo'
      conf.field :url,'http://www.nicovideo.jp'

      conf.on do|r1|
        'http://tn-skr.smilevideo.jp/smile?i='+r1
      end
    end

    rule /img.ly\/([\d\w]+)/i do|conf|
      conf.field :service, 'img.ly'
      conf.field :url, 'http://img.ly'

      conf.on do|r1|
        'http://img.ly/show/thumb/'+r1
      end
    end

    rule /plixi.com\/p\/([\d]+)/i do|conf|
      conf.field :service, 'plixi'
      conf.field :url, 'http://plixi.com'

      conf.on do|r1|
        'http://api.plixi.com/api/tpapi.svc/json/imagefromurl?size=thumbnail&url=http://plixi.com/p/'+r1
      end
    end

    rule %r!dl\.dropbox\.com/u/(.*(?:jpg|png|gif|jpeg))! do|conf|
      conf.field :service, 'Dropbox'
      conf.field :url, 'http://dropbox.com'
      conf.on do|r1|
        'http://dl.dropbox.com/u/'+r1
      end
    end

    rule %r!gyazo\.com/(.+)(?:\.png)?! do|conf|
      conf.field :service, 'Gyazo'
      conf.field :url, 'http://gyazo.com'
      conf.on do|r1|
        'http://gyazo.com/'+ File.basename(r1,'.png') + '.png'
      end
    end

    rule /instagr\.am\/p\/([\w\-]+)/ do|conf|
      conf.field :service, 'Instagram'
      conf.field :url,'http://instagr.am'
      conf.on do|r1|
        'http://instagr.am/p/' + r1 + '/media/?size=t'
      end
    end

    rule /(.*\.(?:jpg|jpeg|png|gif)\z)/i do|conf|
      conf.field :service, 'other(direct link)'

      conf.on do|r1|
        r1
      end
    end
  end
end
