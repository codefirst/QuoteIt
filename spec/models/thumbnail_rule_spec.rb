require 'spec_helper'

describe ThumbnailRule do
  describe "Rule execution" do
    context "rule matched" do
      subject {
        ThumbnailRule.run_rule('http://example.com/foo',
                           :regexp => 'example\\.com/(.*)',
                           :thumbnail => 'http://example.com/$1.png')
      }
      it { should == 'http://example.com/foo.png' }
    end

    context "rule unmatched" do
      it { expect {
          ThumbnailRule.run_rule('http://codefirst.org',
                             :regexp => 'example\\.com/(.*)',
                             :thumbnail => 'http://example.com/$1.png')
        }.to raise_error(ThumbnailRule::NotMatchError)
      }
    end
  end

  describe "select best rule" do
    before do
      [
        FactoryGirl.build(:codefirst_rule),
        FactoryGirl.build(:example_rule)
      ].each(&:save)
    end

    context "first rule" do
      subject { ThumbnailRule.quote 'http://codefirst.org/foo' }
      it { should == 'http://codefirst.org/foo.png' }
    end

    context "second rule" do
      subject { ThumbnailRule.quote 'http://example.com/foo' }
      it { should == 'http://example.com/foo.png' }
    end
  end
end
