set :environment, :development

# every 20.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
#   # the following tasks are run in parallel (not in sequence)
#   rake "youtube:random"
# end

every 12.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
  # the following tasks are run in parallel (not in sequence)
  rake "youtube:facebook"
end
