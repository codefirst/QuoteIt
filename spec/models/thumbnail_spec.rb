require 'spec_helper'

describe "Thumbnail Model" do
  describe "Rule registration" do
    Rule1 = {
      'name'   => 'rule1',
      'updated_at' => Time.now.to_s,
      'data' => {
        'regexp' => '',
        'thumbnail' => '',
        'url' => ''
      }
    }

    Rule2 = {
      'name'   => 'rule2',
      'updated_at' => Time.now.to_s,
      'data' => {
        'regexp' => '',
        'thumbnail' => '',
        'url' => ''
      }
    }

    before { Thumbnail.delete_all }
    subject { Thumbnail }

    its(:count) { should == 0 }

    it { expect {
        Thumbnail.update! [ Rule1, Rule2 ]
      }.to change(Thumbnail, :count).by(2)
    }

    describe "clear old data" do
      it { expect {
          Thumbnail.update! [ Rule1 ]
          Thumbnail.update! [ Rule2 ]
        }.to change(Thumbnail, :count).by(1)
      }
    end
  end

  describe "Rule execution" do
    context "rule matched" do
      subject {
        Thumbnail.run_rule('http://example.com/foo',
                           :regexp => 'example\\.com/(.*)',
                           :thumbnail => 'http://example.com/$1.png')
      }
      it { should == 'http://example.com/foo.png' }
    end

    context "rule unmatched" do
      it { expect {
          Thumbnail.run_rule('http://codefirst.org',
                             :regexp => 'example\\.com/(.*)',
                             :thumbnail => 'http://example.com/$1.png')
        }.to raise_error(Thumbnail::NotMatchError)
      }
    end
  end

  describe "select best rule" do
    before do
      Thumbnail.update! [
                         {
                           'name'   => 'rule1',
                           'updated_at' => Time.now.to_s,
                           'data' => {
                             'regexp' => 'codefirst\.org/(.*)',
                             'thumbnail' => 'http://codefirst.org/$1.png',
                             'url' => 'http://www.codefirst.org'
                           }
                         },
                         {
                           'name'   => 'rule1',
                           'updated_at' => Time.now.to_s,
                           'data' => {
                             'regexp' => 'example\.com/(.*)',
                             'thumbnail' => 'http://example.com/$1.png',
                             'url' => 'http://example.com'
                           }
                         },
                        ]
    end

    context "first rule" do
      subject { Thumbnail['http://codefirst.org/foo'] }
      it { should == 'http://codefirst.org/foo.png' }
    end

    context "second rule" do
      subject { Thumbnail['http://example.com/foo'] }
      it { should == 'http://example.com/foo.png' }
    end
  end
end
