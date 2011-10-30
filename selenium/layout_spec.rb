require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "About" do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @driver.get "http://quoteit.heroku.com"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end

  it "about" do
    @driver.find_element(:link, "About").click
    (@driver.title).should == "Quote It - quote webpage contents"
  end

  it "top page" do
    @driver.find_element(:link, "Quote It").click
    (@driver.title).should == "Quote It - quote webpage contents"
  end

  it "home" do
    @driver.find_element(:link, "Home").click
    (@driver.title).should == "Quote It - quote webpage contents"
  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
end
