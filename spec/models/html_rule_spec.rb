# -*- coding: utf-8 -*-
require 'spec_helper'
require 'stringio'

describe HtmlRule do
  describe "Rule execution" do
    context "rule matched" do
      subject {
        HtmlRule.run_rule('http://example.com/foo',
                      regexp: 'example\\.com/(.*)',
                      clip: 'http://example.com/$1.png')
      }
      it { should be_include('http://example.com/foo.png')}
    end

    context "rule unmatched" do
      it { expect {
          HtmlRule.run_rule('http://codefirst.org',
                        regexp: 'example\\.com/(.*)',
                        clip: 'http://example.com/$1.png')
        }.to raise_error(HtmlRule::NotMatchError)
      }
    end
  end

  describe "transform" do
    before do
      OpenURI.stub(:open_uri) {
        StringIO.new( '{ "div" : "json_content" }')
      }
    end
    describe "original_url" do
      subject {
        HtmlRule.run_rule('http://example.com/foo',
                          regexp: 'http://example\.com/(.*)',
                          clip: 'http://example.com/$1.jpg',
                      transform: 'original_url')
      }
      it { should be_include('http://example.com/foo') }
    end

    describe "clip_url" do
      subject {
        HtmlRule.run_rule('http://example.com/foo',
                          regexp: 'http://example\.com/(.*)',
                          clip: 'http://example.com/$1.json',
                      transform: 'clip_url')
      }
      it { should be_include('http://example.com/foo.json') }
    end

    context "empty clip" do
      subject {
        HtmlRule.run_rule('http://example.com/foo',
                          regexp: 'example\\.com/(.*)',
                          clip: nil,
                          transform: '$1')
      }
      it { should be_include('foo') }
    end

  end

  describe "select best rule" do
    before do
      [
        FactoryGirl.build(:html_rule_a),
        FactoryGirl.build(:html_rule_b),
        FactoryGirl.build(:html_rule_c)
      ].each(&:save)

      OpenURI.stub(:open_uri) {
        StringIO.new( '{ "div" : "json_content" }')
      }
    end

    context "first rule" do
      subject { HtmlRule.quote 'http://codefirst.org/foo' }
      it { should be_include('http://codefirst.org/foo.html') }
    end

    context "second rule" do
      subject { HtmlRule.quote 'http://example.com/foo' }
      it { should be_include('http://example.com/foo.html') }
    end

    context "transform" do
      subject { HtmlRule.quote 'http://json.com/foo' }
      it { should be_include('json_content') }
    end

    context "opengraph" do
      before do
        OpenGraph.should_receive(:fetch) {
          OpenStruct.new(:title => 'hoge')
        }
      end

      subject { HtmlRule.quote 'http://hoge.com' }
      it { should be_include 'hoge' }
    end

    context "fallback" do
      before do
        ThumbnailRule.should_receive(:quote) {
          'http://example.com/foo.png'
        }
      end
      subject { HtmlRule.quote 'http://hoge.com' }
      it { should be_include 'http://example.com/foo.png' }
    end
  end
end
