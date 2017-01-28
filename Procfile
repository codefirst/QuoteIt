release: bundle exec rake db:migrate && bundle exec rake db:seed
web: bundle exec thin start -p $PORT -e $RACK_ENV
