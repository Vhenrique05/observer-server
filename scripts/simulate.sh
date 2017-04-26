#!/bin/sh

TCP_HOST=${TCP_HOST:-localhost}
TCP_PORT=6667
WEB_PORT=8080

SLEEP_TIME=10
COMMAND_SLEEP_TIME=2

KEY=`curl -H "Content-Type: application/json" -X POST "http://$TCP_HOST:8080/users" -d '{"email":"admin@example.com","password":"123456"}' | jq -r ".auth_key"`

while true
do
  (
    printf "v:$KEY\n"
    sleep $COMMAND_SLEEP_TIME
    printf "i:$KEY:W3sidmFsdWUiOiJleGFtcGxlIiwidHlwZSI6InN0cmluZyIsIm5hbWUiOiJ0ZXN0aW5nMSJ9LHsidmFsdWUiOiItMSIsInR5cGUiOiJpbnRlZ2VyIiwibmFtZSI6InRlc3RpbmcyIn1d\n"
    sleep $COMMAND_SLEEP_TIME
    printf "l:$KEY:W3sidGltZXN0YW1wIjoxMjMxMjMxMjMsIm1lc3NhZ2UiOiJ0ZXN0aW5nMSJ9LHsidGltZXN0YW1wIjoxMjMxMjMxMjMsIm1lc3NhZ2UiOiJ0ZXN0aW5nMiJ9XQ==\n"
  ) | telnet $TCP_HOST $TCP_PORT

  sleep $SLEEP_TIME
done
