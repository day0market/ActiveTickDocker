#!/bin/bash

echo "Health check started"
response=$(curl GET "at_server:5000/barData?symbol=MSFT&historyType=0&intradayMinutes=10&beginTime=20101103093000&endTime=20101103160000" | grep "20101103093000")
if [ "$response" = "" ]; then
  exit 1
else
  exit 0
fi
