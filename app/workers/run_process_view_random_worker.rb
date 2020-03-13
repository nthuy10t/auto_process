class RunProcessViewRandomWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform
    type = 'mobile'
    browser = BrowserServices.new(type)
    browser.action_view_random('http://youtube.com')
  end
end
