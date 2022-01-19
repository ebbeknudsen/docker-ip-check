#!/bin/bash

CHANGE_LOGFILE=/change.log
ADDRESS_LOGFILE=/current-address

touch $ADDRESS_LOGFILE

OLD_IP=$(cat $ADDRESS_LOGFILE)
CUR_IP=$(curl -s ipconfig.io)
UNCHANGED_LOG="IP unchanged: $CUR_IP"
CHANGED_LOG="Detected an IP change. Old: $OLD_IP, new: $CUR_IP"

if [ "$OLD_IP" == "$CUR_IP" ]; then
  echo "$UNCHANGED_LOG"

else
  echo "$CHANGED_LOG"
  echo "$(date): $CHANGED_LOG" >> $CHANGE_LOGFILE

  echo "$CUR_IP" > $ADDRESS_LOGFILE

  /bin/bash /scripts/ip-changed.sh $CUR_IP $OLD_IP
fi

/bin/bash /scripts/ip-check-finished.sh $CUR_IP $OLD_IP


