module QuoteUtil
  def eval_regexp(str, regexp, new)
    match = Regexp.new(regexp).match(str)
    if match then
      new = new.to_s.dup
      match.captures.each_with_index do|capture,i|
        new.gsub!("$$#{i+1}", CGI.escape(capture)) if capture
      end
      match.captures.each_with_index do|capture,i|
        new.gsub!("$#{i+1}", capture) if capture
      end
      new
    end
  end
end
