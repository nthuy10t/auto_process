namespace :gmail do
  desc "View youtube from youtube"
  task cookies: :environment do
    RunProcessSaveCookiesYoutubeWorker.perform_async
  end
end
