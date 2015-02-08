require 'quoteit/parser'

describe Quoteit::Parser do
  let :service do
    {
      'name'=> 'service_name',
      'url' => 'http://example.com'
    }
  end

  let :thumbnail do
    {
      'regexp' => 'regexp',
      'thumbnail'=> 'thumbnail',
      'service'  => service
    }
  end

  let :html do
    {
      'regexp' => 'regexp',
      'clip'   => 'clip',
      'transform' => 'transform',
      'service' => service
    }
  end

  describe 'service' do
    context 'new recoard' do
      before do
        expect(Service).to receive(:where).and_return([])
      end

      subject do
        Quoteit::Parser.load('thumbnails' => [ thumbnail ])[:thumbnails].first.service
      end

      its(:id)   { should == nil }
      its(:name) { should == 'service_name' }
      its(:url)  { should == 'http://example.com' }
    end

    context 'exist recoard' do
      before do
        expect(Service).to receive(:where).with(name: 'service_name').and_return(
          [ Service.new(id: 1) ]
        )
      end

      subject do
        Quoteit::Parser.load('thumbnails' => [ thumbnail ])[:thumbnails].first.service
      end



      its(:id)   { should == 1 }
      its(:name) { should == 'service_name' }
      its(:url)  { should == 'http://example.com' }
    end
  end

  describe 'thumbnail' do
    context 'new recoard' do
      before do
        expect(ThumbnailRule).to receive(:where).and_return([])
      end

      subject do
        Quoteit::Parser.load('thumbnails' => [ thumbnail ])[:thumbnails].first
      end

      its(:id)     { should == nil }
      its(:regexp) { should == 'regexp' }
      its(:thumbnail) { should == 'thumbnail' }
    end

    context 'exist recoard' do
      before do
        expect(ThumbnailRule).to receive(:where).with(regexp: 'regexp').and_return(
          [ ThumbnailRule.new(id: 1) ]
        )
      end

      subject do
        Quoteit::Parser.load('thumbnails' => [ thumbnail ])[:thumbnails].first
      end

      its(:id) { should == 1 }
      its(:regexp) { should == 'regexp' }
      its(:thumbnail) { should == 'thumbnail' }
    end
  end

  describe 'html' do
    context 'new recoard' do
      before do
        expect(HtmlRule).to receive(:where).and_return([])
      end

      subject do
        Quoteit::Parser.load('htmls' => [ html ])[:htmls].first
      end

      its(:id)     { should == nil }
      its(:regexp) { should == 'regexp' }
      its(:clip) { should == 'clip' }
      its(:transform) { should == 'transform' }
    end

    context 'exist recoard' do
      before do
        expect(HtmlRule).to receive(:where).with(regexp: 'regexp').and_return(
          [ HtmlRule.new(id: 1) ]
        )
      end

      subject do
        Quoteit::Parser.load('htmls' => [ html ])[:htmls].first
      end

      its(:id) { should == 1 }
      its(:regexp) { should == 'regexp' }
      its(:clip) { should == 'clip' }
      its(:transform) { should == 'transform' }
    end
  end

end
