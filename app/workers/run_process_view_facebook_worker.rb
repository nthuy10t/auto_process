class RunProcessViewFacebookWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform
    type = 'mobile'
    browser = BrowserServices.new(type)
    number_rand = rand(0..2)
    if number_rand == 0
      browser.action_view_random('http://youtube.com')
    else
      browser.action_view_from_facebook('https://www.facebook.com/')
    end
  end
end
