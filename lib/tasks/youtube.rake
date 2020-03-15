namespace :youtube do
  # desc "View random youtube"
  # task random: :environment do
  #   RunProcessViewRandomWorker.perform_async
  # end

  desc "View youtube from youtube"
  task facebook: :environment do
    RunProcessViewFacebookWorker.perform_async('pt4wdBFI1yzYqg4FDke8zzxlYrBhuRoC')
  end

  desc "Task description"
  task facebook_2: :environment do
    RunProcessViewFacebookWorker.perform_async('CRLRlSDt2Bri8jUtNsuSOtQpu0R7IcNg')
  end
end
