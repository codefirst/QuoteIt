require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Search" do
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

  it "thumbnail" do
    (@driver.title).should == "Quote It - quote webpage contents"
    @driver.find_element(:name, "u").clear
    @driver.find_element(:name, "u").send_keys "http://twitpic.com/73wiod"
    @driver.find_element(:xpath, "//input[@value='Quote It']").click
    (@driver.title).should == "Quote It - quote webpage contents"
  end

  it "clip" do
    (@driver.title).should == "Quote It - quote webpage contents"
    @driver.find_element(:name, "u").clear
    @driver.find_element(:name, "u").send_keys "https://twitter.com/#!/twitter/status/91890490089275392"
    @driver.find_element(:xpath, "//input[@value='Quote It']").click
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
