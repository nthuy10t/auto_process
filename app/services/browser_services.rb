require 'capybara'
class BrowserServices
  include BrowserInit
  include HttpServices

  attr_accessor :browser, :time_out, :begin_time, :airtable, :gmail, :email

  def initialize(type)
    response = get_proxy()
    puts(response)
    airtable = init_airtable
    records_airtable = airtable.all(filter: "{last_login} = ''")
    check_airtable(records_airtable)
    self.gmail = records_airtable[rand(0...records_airtable.size)]
    register_browser(type, response['proxy'], gmail['ug_mobile'])
    self.email = gmail['name']
    self.browser = Capybara::Session.new(:selenium_chrome)
    self.time_out = response['timeout']
    self.begin_time = Time.now
  end

  # View random videos
  def action_view_random(url='http://youtube.com')
    # Visit url
    browser.visit(url)
    browser.driver.quit

    # Add cookies
    restored = add_cookies(email)
    quit_browser unless restored

    # Refresh browser
    browser.visit(url)

    # Get all video home and click view random
    sleep_step
    videos = browser.all('a img')
    video  = videos[rand(0...videos.size)]
    sleep_step
    video.click

    # Sleep view first video
    sleep(rand(450..650))

    # Get all video recomend and click view random
    videos = browser.all('a div img')
    video  = videos[rand(0...videos.size)]
    video.click

    Check timeout
    while true
      quit_browser and return if Time.now - begin_time >= (time_out)
      sleep(120)
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
    # save_cookies(email)

    # check timeout
    while true
      quit_browser and return if Time.now - begin_time >= self.time_out
    end
  rescue Exception
    quit_browser
  end

  private

  def quit_browser
    # Save cookies
    save_cookies(email)

    # Update record airtable
    update_airtable

    browser.driver.quit
  end

  def add_cookies(email)
    filename = "vendor/cookies/#{email}.txt"
    return browser.restore_cookies(Rails.root.join(filename)) if Dir[Rails.root.join(filename)].present?
    nil
  end

  def save_cookies(email)
    filename = "vendor/cookies/#{email}.txt"
    browser.save_cookies(Rails.root.join(filename))
  end

  def init_airtable
    airtable = Airrecord.table(ENV['AIRTABLE_KEY'], ENV['AIRTABLE_ID'], ENV['AIRTABLE_NAME'])
    self.airtable = airtable
  end

  def update_airtable
    gmail['last_login'] = DateTime.now.to_date.to_s
    gmail.save
  end

  def check_airtable(records_airtable)
    return if records_airtable.size > 1

    airtable.all.each do |record|
      record['last_login'] = ''
      record.save
    end
  end

  def sleep_step
    sleep(rand(2..5))
  end
end
