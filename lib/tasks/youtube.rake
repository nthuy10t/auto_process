namespace :youtube do
  desc "View random youtube"
  task random: :environment do
    RunProcessViewRandomWorker.perform_async
  end
end
