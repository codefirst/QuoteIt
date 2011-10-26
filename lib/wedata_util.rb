#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module WedataUtil
  def eval_regexp(str, regexp, new)
    match = Regexp.new(regexp).match(str)
    new = new.dup
    match.captures.each_with_index do|capture,i|
      new.gsub!("$#{i+1}", capture)
    end
    new
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

  def update_by!(items, &f)
    self.where(:source => 'wedata').delete_all
    items.each do|item|
      opt = f[item['data']].merge(:name       => item['name'],
                                  :source     => 'wedata',
                                  :updated_at => Time.parse(item['updated_at']))
      self.create(opt)
    end
  end

  module_function :eval_regexp
end
