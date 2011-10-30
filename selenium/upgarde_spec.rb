require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Upgrade" do

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

  it "upgrade" do
    (@driver.title).should == "Quote It - quote webpage contents"
    @driver.find_element(:link, "Upgrade").click
    (@driver.title).should == "Upgrade plugins - Quote It"
    @driver.find_element(:css, "input.danger.btn").click
    (@driver.title).should == "Upgrade plugins - Quote It"
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
