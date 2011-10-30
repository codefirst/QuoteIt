require 'spec_helper'

describe "WedataController" do
  before do
    Kernel.stub(:open).and_yield{ StringIO.new('[]') }
    Thumbnail.stub(:update!)
    Html.stub(:update!)
  end

  describe "index" do
    before { get '/upgrade' }
    it_should_behave_like "success"
  end

  describe "update" do
    before { post '/wedata/update' }

    subject { last_response }
    its(:status) { should < 400 }

    describe "header" do
      subject { last_response.header }
      its(['Location']) { should == 'http://example.org/upgrade' }
    end
  end
end
