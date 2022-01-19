#!/bin/bash

CHANGE_LOGFILE=/change.log
ADDRESS_LOGFILE=/current-address

touch $ADDRESS_LOGFILE

OLD_IP=$(cat $ADDRESS_LOGFILE)
CURRENT_IP=$(curl -s ipconfig.io)

if [ -z "$OLD_IP"]; then
  echo "Old IP not found, setting to empty"
  OLD_IP="(empty)"
fi

if [ "$OLD_IP" == "$CURRENT_IP" ]; then
  UNCHANGED_LOG="IP unchanged: $CURRENT_IP"
  echo "$UNCHANGED_LOG"
  echo ""

else
  CHANGED_LOG="Detected an IP change. Old: $OLD_IP, new: $CURRENT_IP"
  echo "$CHANGED_LOG"
  echo ""

  echo "$(date): $CHANGED_LOG" >> $CHANGE_LOGFILE

  echo "$CURRENT_IP" > $ADDRESS_LOGFILE

  /bin/bash /scripts/ip-changed.sh $CURRENT_IP $OLD_IP
fi

/bin/bash /scripts/ip-check-finished.sh $CURRENT_IP $OLD_IP


