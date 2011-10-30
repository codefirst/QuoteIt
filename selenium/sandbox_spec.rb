require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Sandbox" do

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
    @driver.find_element(:link, "Sandbox").click
    sleep 1
    (@driver.title).should == "Sandbox - Quote It"
    @driver.find_element(:name, "regexp").clear
    @driver.find_element(:name, "regexp").send_keys "instagr\\.am\\/p\\/([\\w\\-]+)"
    @driver.find_element(:name, "thumbnail").clear
    @driver.find_element(:name, "thumbnail").send_keys "http://instagr.am/p/$1/media/?size=t"
    @driver.find_element(:name, "url").clear
    @driver.find_element(:name, "url").send_keys "http://instagr.am/p/RSU8j/"
    @driver.find_element(:css, "input.btn.primary").click
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
