class RunProcessSaveCookiesYoutubeWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform
    type = 'mobile'
    browser = GmailServices.new(type)
    browser.action_get_cookies_gmail('https://accounts.google.com/')
  end
end
