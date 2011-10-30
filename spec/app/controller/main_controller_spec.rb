require 'spec_helper'
require 'ostruct'

describe "MainController" do
  describe "/" do
    before { get "/" }
    it_should_behave_like "success"
  end

  describe "/about" do
    before { get "/about" }
    it_should_behave_like "success"
  end

  describe "/plugins" do
    context "empty" do
      before do
        Thumbnail.stub(:all => [])
        Html.stub(:all => [])
        get "/plugins"
      end
      it_should_behave_like "success"
    end

    context "one" do
      def rule(name)
        OpenStruct.new(:name => name)
      end

      before do
        Thumbnail.stub(:all => [ rule("alice"), rule("bob") ])
        Html     .stub(:all => [ rule("alice"), rule("bob") ])
        get "/plugins"
      end

      it_should_behave_like "success"
    end
  end
end
