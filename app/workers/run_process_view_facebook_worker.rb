class RunProcessViewFacebookWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform
    type = 'mobile'
    browser = YoutubeServices.new(type)
    browser.action_view_from_facebook('https://www.facebook.com/')
  end
end
