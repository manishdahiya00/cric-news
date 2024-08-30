set :output, "log/whenever.log"

job_type :rake, "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"

every 6.hours do
  rake "fetchMatches:upcomingMatches"
  rake "fetchMatches:livMatches"
  rake "fetchMatches:completedMatches"
end
