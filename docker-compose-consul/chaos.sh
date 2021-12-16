#!/bin/bash

query() {
echo "Response:"
RESULT=$(curl 'http://localhost:8080/api' \
      -H 'Accept-Encoding: gzip, deflate, br' \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      -H 'Connection: keep-alive' \
      -H 'DNT: 1' \
      -H 'Origin: http://localhost:8080' \
      -w "%{http_code}" \
      --silent \
      --data-binary '{"query":"mutation{ pay(details:{ name: \"nic\", type: \"mastercard\", number: \"1234123-0123123\", expiry:\"10/02\",    cv2: 1231, amount: 12.23 }){id, card_plaintext, card_ciphertext, message } }"}')
echo $RESULT | jq -C .

http_code=$(echo $RESULT | jq -C . | tail -1)

echo "HTTP return code: $http_code"

 if [ $? != 0 ]; then
        echo "ERROR: Failed connecting to the API"
 fi
 echo " "
}


COUNTER=0
seq 5 | while true; do

query

COUNTER=$[$COUNTER + 1]
echo "Iteration #: $COUNTER"
echo "####################################"
sleep 1

done