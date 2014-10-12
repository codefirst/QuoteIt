require 'spec_helper'

describe QuotesController do
  context 'show' do
    context 'with nil' do
      before { get :show, :u => nil }
      subject { response }
      its(:response_code) { should eq 404 }
    end
    context 'with invalid' do
      before { get :show, :u => 'http://' }
      subject { response }
      its(:response_code) { should eq 404 }
    end
    context 'with blacklisted url' do
      before { get :show, :u => 'http://localhost/' }
      subject { response }
      its(:response_code) { should eq 404 }
    end
  end
  context 'html' do
    context 'with nil' do
      before { get :html, :format => 'json', :u => nil }
      subject { response }
      its(:response_code) { should eq 404 }
    end
    context 'with HTTPError 404' do
      before {
        err = OpenURI::HTTPError.new('404 Not Found', nil)
        HtmlRule.stub(:quote).and_raise(err)
        get :html, :format => 'json', :u => 'http://www.example.com'
      }
      subject { response }
      its(:response_code) { should eq 404 }
    end
    context 'with HTTPError 403' do
      before {
        err = OpenURI::HTTPError.new('403 Forbidden', nil)
        HtmlRule.stub(:quote).and_raise(err)
        get :html, :format => 'json', :u => 'http://www.example.com'
      }
      subject { response }
      its(:response_code) { should eq 403 }
    end
    context 'with HTTPError 503' do
      before {
        err = ::OpenURI::HTTPError.new('503 Service Unavailable', nil)
        HtmlRule.stub(:quote).and_raise(err)
        get :html, :format => 'json', :u => 'http://www.example.com'
      }
      subject { response }
      its(:response_code) { should eq 503 }
    end
  end
end
