#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Webclip
  class Webclip
    def self.rule(regexp, &f)
      @rules ||= []
      @rules << [ regexp, f ]
    end

    def self.any(xs, &f)
      (xs || []).each do|*x|
        ret = f[*x]
        return ret if ret
      end
      return nil
    end

    def self.best_match(url)
      any(@rules) do| regexp, handle |
        if (m = regexp.match(url)) then
          handle[*m.captures]
        end
      end
    end
  end
end
