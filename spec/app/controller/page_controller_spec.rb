require 'spec_helper'

describe "PageController" do
  before do
    Thumbnail.stub(:[] => 'http://example.com/foo.png')
    Html     .stub(:[] => '<div>foo</div>')
  end

  describe "/thumbnail" do
    describe "text" do
      before { get "/thumbnail.txt?u=x" }
      it_should_behave_like "success"

      subject { last_response.body }
      it { should == 'http://example.com/foo.png' }
    end

    describe "json" do
      before { get "/thumbnail.json?u=x" }
      it_should_behave_like "success"

      subject { JSON.parse last_response.body }
      its(['status']) { should == 'ok' }
      its(['url'])    { should == 'x'  }
      its(['thumbnail']) { should == 'http://example.com/foo.png' }
    end

    describe "redirect" do
      before { get "/thumbnail.jpg?u=x" }
      subject { last_response }
      its(:status) { should < 400 }

      describe "header" do
        subject { last_response.header }
        its(['Location']) { should == 'http://example.com/foo.png' }
      end
    end
  end

  describe "/clip" do
    describe "html" do
      before { get "/clip.html?u=x" }
      it_should_behave_like "success"
    end

    describe "json" do
      before { get "/clip.json?u=x" }
      it_should_behave_like "success"
      subject { JSON.parse last_response.body }
      its(['status']) { should == 'ok' }
      its(['url'])    { should == 'x'  }
      its(['html'])   { should == '<div>foo</div>' }
    end
  end
end
