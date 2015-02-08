require 'rails_helper'

describe Service do
  describe 'predicate' do
    context 'none' do
      subject do
        FactoryGirl.build(:service_a).tap do|s|
          allow(s).to receive(:thumbail_rules).and_return([])
          allow(s).to receive(:html_rules).and_return([])
        end
      end

      it { should_not be_clip }
      it { should_not be_thumbnail }
    end

    context 'both' do
      subject do
        FactoryGirl.build(:service_a).tap do|s|
          allow(s).to receive(:thumbnail_rules).and_return([double(ThumbnailRule)])
          allow(s).to receive(:html_rules).and_return([double(HtmlRule)])
        end
      end

      it { should be_clip }
      it { should be_thumbnail }
    end
  end
end
