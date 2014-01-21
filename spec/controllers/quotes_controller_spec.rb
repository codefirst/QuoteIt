require 'spec_helper'

describe QuotesController do
  context 'show' do
    before { get :show, :u => nil }
    subject { response }
    its(:response_code) { should eq 404 }
  end
end
