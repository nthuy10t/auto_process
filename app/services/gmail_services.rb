require 'capybara'
require 'open-uri'
class GmailServices
  include BrowserInit
  include HttpServices

  attr_accessor :browser, :airtable_ug, :airtable_mails

  def initialize(type)
    response = get_proxy('CRLRlSDt2Bri8jUtNsuSOtQpu0R7IcNg')
    airtable_ug = init_airtable
    ug_records_airtable = airtable_ug.all(filter: "{last_use} = ''")
    user_gent = ug_records_airtable[rand(0...ug_records_airtable.size)]
    register_browser(type, response['proxy'], user_gent['name'])
    self.browser = Capybara::Session.new(:selenium_chrome)
  end

  def action_get_cookies_gmail(url)
    browser.visit(url)
    # Get list mails
    mail_records_airtable = airtable_mails.all(filter: "{save_cookies} = ''")

    # Get random mail
    mail = mail_records_airtable[rand(0...mail_records_airtable.size)]
    sleep_step

    # Login mail
    browser.first('input[type="email"]', visible: false).set(mail['name'])
    sleep_step
    browser.first('#identifierNext').click
    sleep_step
    browser.first('input[type="password"]', visible: false).set(mail['pass'])
    sleep_step
    browser.first('#passwordNext').click
    sleep_step
    # By pass captcha
    if browser.has_content?('Chào mừng')
      sleep_step
      result = bypass_captcha
      id     = result.last if result.first == 'OK'

      if id.present?
        sleep(rand(25..30))
        result_captcha = get_captcha(id)
        captcha = result_captcha.last if result_captcha.first == 'OK'
        if captcha.present?
          input_captcha(mail, captcha)
          sleep_step
          if browser.has_content?('Chào mừng')
            sleep_step
            result = bypass_captcha
            id     = result.last if result.first == 'OK'
            if id.present?
              sleep(rand(25..30))
              result_captcha = get_captcha(id)
              captcha = result_captcha.last if result_captcha.first == 'OK'
              if captcha.present?
                input_captcha(mail, captcha)
                unless browser.has_content?('Chào mừng')
                  save_cookies(mail)
                end
              end
            end
          else
            verify_sub_mail(mail)
            sleep_step
            save_cookies(mail)
          end
        end
      end
    end
    sleep(rand(50..80))
    browser.driver.quit
  rescue Exception => e
    browser.driver.quit
  end

  private

  def init_airtable
    airtable_ug = Airrecord.table(ENV['AIRTABLE_KEY'], ENV['AIRTABLE_ID'], 'UG_REG')
    airtable_mails = Airrecord.table(ENV['AIRTABLE_KEY'], ENV['AIRTABLE_ID'], 'MAILS_LIST')
    self.airtable_mails = airtable_mails
    self.airtable_ug = airtable_ug
  end

  def captcha_base64
    download = open(browser.first('#captchaimg')['src'])
    image_captcha = "#{Rails.root}/vendor/image_captcha/test.jpg"
    IO.copy_stream(download, "#{Rails.root}/vendor/image_captcha/test.jpg")
    base64 = img64(image_captcha)
  end

  def bypass_captcha
    conn = Faraday.new('https://2captcha.com')
    base64 = captcha_base64
    response = conn.post('/in.php',
      { key: 'd9a4857a9dc305033247070adbffcc4f', method: 'base64', body: base64 }.to_json,
      {'Content-Type'=>'application/json'}
    )
    response.body.split('|')
  end

  def get_captcha(id)
    conn = Faraday.new('https://2captcha.com')
    response = conn.get do |req|
      req.url '/res.php'
      req.params['key']    = 'd9a4857a9dc305033247070adbffcc4f'
      req.params['action'] = 'get'
      req.params['id']     = id
    end
    response.body.split('|')
  end

  def input_captcha(mail, captcha)
    sleep_step
    browser.first('input[type="password"]', visible: false).set(mail['pass'])
    sleep_step
    browser.first('input[type="text"]', visible: false).set(captcha)
    sleep_step
    browser.first('#passwordNext').click
    sleep_step
  end

  def verify_sub_mail(mail)
    sleep_step
    browser.first('li div div', text: 'Xác nhận email khôi phục của bạn').click
    sleep_step
    browser.first('input[type="email"]', visible: false).set(mail['submail'])
    sleep_step
    browser.first('span', text: 'Tiếp theo', visible: false).click
  end

  def save_cookies(mail)
    sleep_step
    browser.first('span', text: 'Xác nhận', visible: false).click if browser.has_content?('Xác nhận')
    sleep_step
    browser.visit('https://www.youtube.com/')
    browser.visit('https://www.youtube.com/')
    file_cookie = mail['name'].split('@').first
    path = "#{Rails.root}/vendor/cookies/youtube/#{file_cookie}.txt"
    browser.save_cookies(path)
    sleep_step
    mail['save_cookies'] = 'save'
    mail.save
  end

  def sleep_step
    sleep(rand(2..5))
  end

  def img64(path)
    File.open(path, 'rb') do |img|
      'data:image/png;base64,' + Base64.strict_encode64(img.read)
    end
  end
end
