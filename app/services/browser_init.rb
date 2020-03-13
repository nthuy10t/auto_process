require 'capybara'
require "selenium/webdriver"
module BrowserInit
  def register_browser(browser_type, proxy, user_agent)
    # Selenium::WebDriver::Chrome.driver_path = "#{Rails.root}/chromedriver/chromedriver"
    Capybara.register_driver :selenium_chrome do |app|
      options = option_argument_init(browser_type, proxy, user_agent)
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 300
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, http_client: client)
    end
  end

  def option_argument_init(browser_type, proxy, user_agent)
    options = Selenium::WebDriver::Chrome::Options.new

    options.add_argument('--disable-plugins-discovery')
    options.add_argument('--disable-bundled-ppapi-flash')
    # options.add_argument('--disable-extensions')
    options.add_argument('--disable-notifications')
    options.add_argument('--window-size=1280,800')
    options.add_option("excludeSwitches",["ignore-certificate-errors"])
    options.add_option("excludeSwitches",["enable-automation"])

    options.add_argument("--proxy-server=#{proxy}")

    # Add emulation
    browser = browser_emulation(browser_type, user_agent)
    options.add_emulation(browser)
    options
  end

  def browser_emulation(browser_type, user_agent)
    return {
      user_agent: user_agent
    } if 'web' == browser_type

    # Mobile setting
    mobile_emulation = { device_metrics: { width: 1280, height: 800, pixelRatio: 1 } }

    return mobile_emulation.merge!(user_agent: user_agent)
  end
end
