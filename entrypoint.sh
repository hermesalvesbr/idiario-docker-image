#!/bin/bash



if ! test -f ".setup"; then
  echo "Iniciando primeira vez:  $(date +'%m/%d/%Y  %H:%M:%S')"
  mkdir -p ${IDIARIO_ROOT}
  tar --strip-components=1 -zxf /tmp/idiario.tar.gz -C ${IDIARIO_ROOT}

  bundle check || BUNDLE_JOBS=4 bundle install
  yarn install

  echo -e "
  production:
    secret_key_base: `bundle exec rake secret`
    redis_url: redis://localhost:6379
    sidekiq_password: Sidekiq_123
    EXAM_POSTING_QUEUES: 'exam_posting_1,exam_posting_2'
    " > config/secrets.yml

  cp config/database.sample.yml config/database.yml

  export RAILS_ENV=production
  bundle
  bundle install --deployment --without development test

  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake assets:precompile
  bundle exec rake entity:setup NAME=prefeitura DOMAIN=localhost DATABASE=idiario
  bundle exec rake entity:admin:create NAME=prefeitura ADMIN_PASSWORD=softagon@2022


  cp public/404.html.sample public/404.html
  cp public/500.html.sample public/500.html

  touch .setup
fi

rm -f /app/tmp/pids/server.pid

echo "Roda o redis.. $(date +'%m/%d/%Y  %H:%M:%S')"
service redis-server start
echo "Roda o sidekiq.. $(date +'%m/%d/%Y  %H:%M:%S') "
RAILS_ENV=production bundle exec sidekiq &
echo "Roda o start servidor $(date +'%m/%d/%Y  %H:%M:%S')"
bundle exec rails server -b 0.0.0.0
