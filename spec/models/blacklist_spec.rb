# -*- coding: utf-8 -*-
require 'spec_helper'

describe Blacklist do
  describe "include?" do
    context "matched" do
      subject { Blacklist.include?('http://localhost/') }
      it { should be_true }
    end
    context "unmatched" do
      subject { Blacklist.include?('http://twitter.com/') }
      it { should be_false }
    end
    context "use ENV" do
      before { ENV['BLACKLIST'] = 'www.codefirst.org' }
      subject { Blacklist.include?('http://www.codefirst.org/') }
      it { should be_true }
    end
  end
end
