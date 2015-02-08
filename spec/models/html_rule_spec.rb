# -*- coding: utf-8 -*-
require 'rails_helper'
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
      allow(OpenURI).to receive(:open_uri) {
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

  describe "transform xml" do
    describe "transform" do
      before do
        allow(OpenURI).to receive(:open_uri) {
          StringIO.new( '<div>xml_content</div>')
        }
      end
      subject {
        HtmlRule.run_rule('http://example.com/foo',
                          regexp: 'http://example\.com/(.*)',
                          clip: 'http://example.com/$1.json',
                      transform: 'json["div"]')
      }
      it { should be_include('xml_content') }
    end

    describe "parse error" do
      before do
        allow(OpenURI).to receive(:open_uri) {
          StringIO.new( '<>')
        }
      end
      subject {
        HtmlRule.run_rule('http://example.com/foo',
                          regexp: 'http://example\.com/(.*)',
                          clip: 'http://example.com/$1.json',
                          transform: 'json')
      }
      it { should eq "<div class='quote-it clip'></div>" }
    end
  end

  describe "select best rule" do
    before do
      [
        FactoryGirl.build(:html_rule_a),
        FactoryGirl.build(:html_rule_b),
        FactoryGirl.build(:html_rule_c)
      ].each(&:save)

      allow(OpenURI).to receive(:open_uri) {
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
        expect(OpenGraph).to receive(:new) {
          OpenStruct.new(:title => 'hoge', :images => [])
        }
      end

      subject { HtmlRule.quote 'http://hoge.com' }
      it { should be_include 'hoge' }
    end

    context "fallback" do
      before do
        expect(ThumbnailRule).to receive(:quote) {
          'http://example.com/foo.png'
        }
      end
      subject { HtmlRule.quote 'http://hoge.com' }
      it { should be_include 'http://example.com/foo.png' }
    end
  end

  describe "quote opengraph" do
    context "without images" do
      before do
        allow(OpenGraph).to receive(:new) {
          OpenStruct.new(
            :title => 'hoge',
            :images => [],
            :url => 'http://hoge.com'
          )
        }
      end
      subject { HtmlRule.quote 'http://hoge.com' }
      it { should_not be_include '<img' }
    end

    context "without description" do
      before do
        allow(OpenGraph).to receive(:new) {
          OpenStruct.new(
            :title => 'hoge',
            :images => [],
            :url => 'http://hoge.com'
          )
        }
      end
      subject { HtmlRule.quote 'http://hoge.com' }
      it { should_not be_include 'description' }
    end

    context "without title" do
      context "and with img" do
        before do
          allow(OpenGraph).to receive(:new) {
            OpenStruct.new(
              :title => 'hoge',
              :images => ['http://hoge.com/icon.png'],
              :url => 'http://hoge.com'
            )
          }
        end
        subject { HtmlRule.quote 'http://hoge.com' }
        it { should_not be_include 'title' }
        it { should be_include '<img' }
      end
      context "and without img" do
        before do
          allow(OpenGraph).to receive(:new) {
            OpenStruct.new(
              :images => [],
              :url => 'http://hoge.com'
            )
          }
        end
        subject { HtmlRule.quote 'http://hoge.com' }
        it { should be_include 'http://hoge.com' }
        it { should_not be_include 'img' }
        it { should_not be_include 'title' }
      end
    end
  end
end
