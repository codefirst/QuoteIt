# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Html Model" do
  describe "Rule registration" do
    Rule = {
      'name'   => 'rule1',
      'updated_at' => Time.now.to_s,
      'data' => {
        'regexp' => '',
        'clip' => '',
        'url' => ''
      }
    }

    before { Html.delete_all }

    subject { Html }

    its(:count) { should == 0 }

    it { expect {
        Html.update! [Rule]
      }.to change(Html, :count).by(1) }
  end

  describe "Rule execution" do
    context "rule matched" do
      subject {
        Html.run_rule('http://example.com/foo',
                      :regexp => 'example\\.com/(.*)',
                      :clip => 'http://example.com/$1.png')
      }
      it { should be_include('http://example.com/foo.png')}
    end

    context "rule unmatched" do
      it { expect {
          Html.run_rule('http://codefirst.org',
                        :regexp => 'example\\.com/(.*)',
                        :thumbnail => 'http://example.com/$1.png')
        }.to raise_error(Html::NotMatchError)
      }
    end
  end

  describe "select best rule" do
    before do
      @cache = mock(:cache)
      @cache.stub(:get => '{ "div" : "json_content" }',
                  :set => nil)
      Thumbnailr.stub(:cache => @cache)

      Html.update! [
                    {
                      'name'   => 'rule1',
                      'updated_at' => Time.now.to_s,
                      'data' => {
                        'regexp'    => 'codefirst\.org/(.*)',
                        'clip'      => 'http://codefirst.org/$1.html',
                        'transform' => ''
                      }
                    },
                    {
                      'name'   => 'rule2',
                      'updated_at' => Time.now.to_s,
                      'data' => {
                        'regexp'    => 'example\.com/(.*)',
                        'clip'      => 'http://example.com/$1.html',
                        'transform' => ''
                      }
                    },
                    {
                      'name'   => 'rule3',
                      'updated_at' => Time.now.to_s,
                      'data' => {
                        'regexp'    => 'json\.com/(.*)',
                        'clip'      => 'http://example.com/$1.json',
                        'transform' => 'json["div"]'
                      }
                    }
                   ]
    end

    context "first rule" do
      subject { Html['http://codefirst.org/foo'] }
      it { should be_include('http://codefirst.org/foo.html') }
    end

    context "second rule" do
      subject { Html['http://example.com/foo'] }
      it { should be_include('http://example.com/foo.html') }
    end

    context "transform" do
      subject { Html['http://json.com/foo'] }
      it { should be_include('json_content') }
    end

    context "fallback" do
      before do
        Thumbnail.should_receive(:[]) {
          'http://example.com/foo.png'
        }
      end
      subject { Html['http://hoge.com'] }
      it { should be_include 'http://example.com/foo.png' }
    end
  end
end
