#!/bin/bash

case "$1" in
  start)
        thin start -C /etc/thin/roundtrialdatabase.yml
        /etc/init.d/nginx start
        ;;
  stop)
        thin stop -C /etc/thin/roundtrialdatabase.yml
        /etc/init.d/nginx stop
        ;;
  restart)
        thin stop -C /etc/thin/roundtrialdatabase.yml
        thin start -C /etc/thin/roundtrialdatabase.yml
        /etc/init.d/nginx restart
        ;;
  assets)
        bundle exec rake assets:precompile
        thin stop -C /etc/thin/roundtrialdatabase.yml
        thin start -C /etc/thin/roundtrialdatabase.yml
        /etc/init.d/nginx restart
        ;;
  sphinx)
        bundle exec rake ts:stop RAILS_ENV=production
        bundle exec rake ts:index RAILS_ENV=production
        bundle exec rake ts:start RAILS_ENV=production
        ;;
  *)
        echo "Usage: $SCRIPT_NAME {start|stop|restart|assets}" >&2
        exit 3
        ;;
esac
