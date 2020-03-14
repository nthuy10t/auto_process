namespace :youtube do
  # desc "View random youtube"
  # task random: :environment do
  #   RunProcessViewRandomWorker.perform_async
  # end

  desc "View youtube from youtube"
  task facebook: :environment do
    RunProcessViewFacebookWorker.perform_async
  end
end
