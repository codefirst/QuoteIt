#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Webclip
  class Rule
    attr_reader :proc

    def initialize
      @fields = {}
    end

    def on(&proc)
      @proc = proc
    end

    def field(name, value)
      @fields[name] = value
    end

    def [](name)
      @fields[name]
    end
  end

  class Webclip
    class << self
      def rule_reset!
        @rules = []
      end

      def rule(regexp, &f)
        @rules ||= []
        rule = Rule.new
        f[rule]
        @rules << [ regexp, rule ]
      end

      def any(xs, &f)
        (xs || []).each do|*x|
          ret = f[*x]
          return ret if ret
        end
        return nil
      end

      def best_match(url)
        any(@rules) do| regexp, rule |
          if (m = regexp.match(url)) then
            rule.proc[*m.captures]
          end
        end
      end

      def all_rules
        @rules.map{|_,rule| rule }
      end
    end
  end
end
