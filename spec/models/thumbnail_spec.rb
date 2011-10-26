require 'spec_helper'

describe "Thumbnail Model" do
  let(:thumbnail) { Thumbnail.new }
  it 'can be created' do
    thumbnail.should_not be_nil
  end
end
