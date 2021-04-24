#!/usr/bin/env zsh

CONFIG=/srv/mirror/mirror.conf
[[ -z $SLEEP_MINS ]] && SLEEP_MINS=10

echo "DESTD=/srv/mirror/content" >> $CONFIG
echo "TIMEFILE=/srv/mirror/timefile" >> $CONFIG
echo "MODULES=(${MODULES})" >> $CONFIG
echo "VERBOSE=${VERBOSE}" >> $CONFIG
[[ -z $CHECKIN_SITE ]] && echo "CHECKIN_SITE=$CHECKIN_SITE" >> $CONFIG
[[ -z $CHECKIN_HOST ]] && echo "CHECKIN_HOST=$CHECKIN_HOST" >> $CONFIG
[[ -z $CHECKIN_PASS ]] && echo "CHECKIN_PASS=$CHECKIN_PASSWORD" >> $CONFIG

while true; do
  ./quick-fedora-mirror -c $CONFIG

  [[ $HARDLINK_OPTIMIZE == "yes" ]] && ./quick-fedora-hardlink -c $CONFIG

  echo Sleeping for $SLEEP_MINS minutes...

  for ((i = $SLEEP_MINS-1; i > 0; i--)) {
    sleep 1m
    echo "$i minutes left..."
  }
done
