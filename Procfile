# migrate/setup trick from https://stackoverflow.com/a/40019538/590525
release: rake db:migrate 2>/dev/null || rake db:setup
web: bundle exec puma -C config/puma.rb
