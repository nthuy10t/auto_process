require 'capybara'
class BrowserServices
  include BrowserInit
  include HttpServices

  attr_accessor :browser, :time_out, :begin_time

  def initialize(type)
    response = get_proxy()
    register_browser(type, response['proxy'])
    self.browser = Capybara::Session.new(:selenium_chrome)
    self.time_out = response['timeout']
    self.begin_time = Time.now
  end

  # View random videos
  def action_view_random(url='http://youtube.com', email)
    # Add action visit, click
    # self.browser.visit(url)

    # add cookies
    # restored = add_cookies(url, email)
    # quit_browser unless restored

    # click video or click trending -> click video
    # self.browser.clcik()

    # save cookies
    # save_cookies(url, email)


    # check timeout
    while true
      quit_browser and return if Time.now - begin_time >= self.time_out
    end
  rescue Exception
    quit_browser
  end

  def action_view_from_facebook(fb_url, email)
    # open link fb
    # self.browser.visit()

    # click link video
    # element = self.browser.driver.first(:xpath, xpath)
    # quit_browser and return unless element

    # get browser url

    # add cookies
    # restored = add_cookies(url, email)
    # quit_browser unless restored
    
    # click play
    # self.browser.click(:xpath, xpath)

    # save cookies
    # save_cookies(url, email)

    # check timeout
    while true
      quit_browser and return if Time.now - begin_time >= self.time_out
    end
  rescue Exception
    quit_browser
  end

  def quit_browser
    self.browser.driver.quit
  end

  def add_cookies(url, email)
    host = URI(url).host
    filename = "tmp/cookie/#{host}_#{email}.cookies.txt"
    self.browser.restore_cookies(Rails.root.join(filename)) if Dir[Rails.root.join(filename)].present?
    nil
  end

  def save_cookies(url_email)
    host = URI(url).host
    filename = "tmp/cookie/#{host}_#{email}.cookies.txt"
    self.browser.save_cookies(Rails.root.join(filename))
  end
end
