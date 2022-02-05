#!/bin/bash

BASE_PATH="${1:-/}";
CHECK_IP_CMD="${CHECK_IP_CMD:-curl -fsS -m 5 --retry 5 ipconfig.io 2>&1}"
CHECK_IP_CMD_FALLBACK="${CHECK_IP_CMD_FALLBACK:-curl -fsS -m 5 --retry 5 api.ipify.org 2>&1}"
CHANGE_LOGFILE="${BASE_PATH}change.log"
ADDRESS_LOGFILE="${BASE_PATH}current-address"

touch $ADDRESS_LOGFILE

OLD_IP=$(cat $ADDRESS_LOGFILE)
CURRENT_IP=$(eval "$CHECK_IP_CMD")

if [ ! -z "CHECK_IP_CMD_FALLBACK" ]; then
  if [[ ! $CURRENT_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "IP response not a valid IP, trying fallback to api.ipify.org. IP response: $CURRENT_IP";
    CURRENT_IP=$(eval "$CHECK_IP_CMD_FALLBACK")
  fi
fi

if [ -z "$OLD_IP" ]; then
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


