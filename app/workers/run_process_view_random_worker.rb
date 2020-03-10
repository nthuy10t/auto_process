class RunProcessViewRandomWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform
    # Get email
    email = 'dennisbattle628'
    type = ['web', 'mobile'].sample
    browser = BrowserServices.new(type)
    browser.action_view_random(nil, email)
  end
end
