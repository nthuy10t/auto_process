require 'capybara'
require "selenium/webdriver"
module BrowserInit
  def register_browser(browser_type, proxy)
    Selenium::WebDriver::Chrome.driver_path = "#{Rails.root}/chromedriver/chromedriver"
    Capybara.register_driver :headless_chrome do |app|
      options = option_argument_init(browser_type, proxy)
      driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, http_client: client_timeout)
      path = '/session/:session_id/chromium/send_command'
      path[':session_id'] = bridge.session_id
      driver
    end
  end

  def option_argument_init(browser_type, proxy)
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
    browser = browser_emulation(browser_type)
    options.add_emulation(browser)
    options
  end

  def browser_emulation(browser_type)
    return {
      user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
    } if [nil, 'web'].include? browser_type

    # Mobile setting
    mobile_emulation = { device_metrics: { width: 1280, height: 10000, pixelRatio: 1 } }

    return mobile_emulation.merge!(user_agent: "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3")
  end
end
