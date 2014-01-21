require 'spec_helper'

describe QuotesController do
  context 'show' do
    before { get :show, :u => nil }
    it { should redirect_to(:controller => 'top', :action => 'index') }
  end
end
