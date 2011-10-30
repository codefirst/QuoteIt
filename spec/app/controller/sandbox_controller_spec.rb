require 'spec_helper'

describe "SandboxController" do
  describe "index" do
    before { get '/sandbox' }
    it_should_behave_like "success"
  end

  describe "/sandbox/thumbnail" do
    before do
      @stub = Thumbnail.should_receive(:run_rule).with('x',
                                                       :regexp => 'regexp',
                                                       :thumbnail => 'thumbnail')
      get '/sandbox/thumbnail?url=x&regexp=regexp&thumbnail=thumbnail'
    end

    subject { @stub }
    it { should be_expected_messages_received }
    it_should_behave_like "success"
  end

  describe "/sandbox/webClip" do
    before do
      @stub = Html.should_receive(:run_rule).with('x',
                                                  :regexp => 'regexp',
                                                  :clip => 'clip',
                                                  :transform => 't')
      get '/sandbox/webClip?url=x&regexp=regexp&clip=clip&transform=t'
    end

    subject { @stub }
    it { should be_expected_messages_received }
    it_should_behave_like "success"
  end
end
