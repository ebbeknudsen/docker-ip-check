#!/bin/bash

echo "*** STARTING CONTAINER ***"
echo ""

echo "Moving default scripts to scripts folder, if they don't already exist"

if [ -d "scripts" ]; then
  echo "* Scripts folder already exists"
else
  echo "* Scripts folder doesn't exist, create it"
  mkdir scripts
fi

DEFAULT_SCRIPT_FILES=( ip-changed.sh ip-check-finished.sh )

for FILE in "${DEFAULT_SCRIPT_FILES[@]}"
do
  if [ -f "scripts/$FILE" ]; then
    echo "* scripts/$FILE already exists, don't overwrite with default"
  else
    echo "* scripts/$FILE doesn't exists, using default script"
    cp "default-scripts/$FILE" "scripts/$FILE"
    chown $PUID:$PGID scripts/$FILE
  fi
done
echo ""

ENV_CRON_EXPRESSION="${CRON_EXPRESSION:-*/1 * * * *}"

RUN_CRON_EXPRESSION="$ENV_CRON_EXPRESSION /check-ip.sh"
echo "Running CRON expression: $RUN_CRON_EXPRESSION"
echo "$RUN_CRON_EXPRESSION" > check-ip-cron
crontab check-ip-cron
rm check-ip-cron


echo "Running check-ip at startup"
/bin/bash /check-ip.sh

echo ""
echo ""
echo "*** CONTAINER STARTED ***"

exec "$@"
