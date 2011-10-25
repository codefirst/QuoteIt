require 'webclip/webclip'

module Webclip
  class Thumbnail < ::Webclip::Webclip
    def self.[](url)
      _,image = best_match(url)
      image
    end

    rule /twitpic\.com\/([A-z0-9]+)/ do|r1|
      unless r1 == "photos" then
        ['http://twitpic.com/'+r1, 'http://twitpic.com/show/thumb/'+r1];
      end
    end

    rule /(f\.hatena\.ne\.jp\/(([^\/])[^\/]+)\/(([0-9]{8})[0-9]+))/i do|r1,r2,r3,r4,r5|
      ['http://'+r1, 'http://img.f.hatena.ne.jp/images/fotolife/'+r3+'/'+r2+'/'+r5+'/'+r4+'_120.jpg']
    end

    rule /movapic\.com\/pic\/([\d\w]+)/i do|r1|
      ['http://movapic.com/pic/'+r1, 'http://image.movapic.com/pic/s_'+r1+'.jpeg']
    end

    rule /yfrog.com\/([\d\w]+)/i do|r1|
      ['http://yfrog.com/'+r1, 'http://yfrog.com/'+r1+'.th.jpg']
    end

    rule /ow.ly\/i\/([\d\w]+)/i do|r1|
      ['http://ow.ly/i/'+r1, 'http://static.ow.ly/photos/thumb/'+r1+'.jpg']
    end

    rule /(youtu\.be\/|www\.youtube\.com\/watch\?v\=)([\d\-\w]+)/i do|r1,r2|
      ['http://youtu.be/'+r2, 'http://i.ytimg.com/vi/'+r2+"/hqdefault.jpg"]
    end

    rule /www\.nicovideo\.jp\/watch\/([a-z]*?)([\d]+)\??/i do|r1,r2|
      ['http://www.nicovideo.jp/watch/'+r1+r2, 'http://tn-skr.smilevideo.jp/smile?i='+r2]
    end

    rule /img.ly\/([\d\w]+)/i do|r1|
      ['http://img.ly/'+r1, 'http://img.ly/show/thumb/'+r1]
    end

    rule /plixi.com\/p\/([\d]+)/i do|r1|
      ['http://plixi.com/p/'+r1, 'http://api.plixi.com/api/tpapi.svc/json/imagefromurl?size=thumbnail&url=http://plixi.com/p/'+r1]
    end

    rule %r!dl\.dropbox\.com/u/(.*(?:jpg|png|gif|jpeg))! do|r1|
      ['http://dl.dropbox.com/u/'+r1, 'http://dl.dropbox.com/u/'+r1]
    end

    rule %r!gyazo\.com/(.+)(?:\.png)?! do|r1|
      ['http://gyazo.com/'+r1, 'http://gyazo.com/'+ File.basename(r1,'.png') + '.png']
    end

    rule /instagr\.am\/p\/([\w\-]+)/ do|r1|
      ['http://instagr.am/p/' + r1, 'http://instagr.am/p/' + r1 + '/media/?size=t']
    end

    rule /(.*\.(?:jpg|jpeg|png|gif)\z)/i do|r1|
      [r1, r1]
    end
  end
end
