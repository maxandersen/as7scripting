#!/usr/bin/bash

## This is using raw curl with error handling left as an excersice to the reader. 

hash=`curl -sS -F "file=@node-info.war;type=application/octet-stream" http://localhost:9990/management/add-content | sed -e "s/.*\"BYTES_VALUE\".*\:.*\"\(.*\)\".*/\1/g"`

echo "The uploaded hash is $hash."

content='{"content":[{"hash":{"BYTES_VALUE":"'$hash'"}}],"address":[{"deployment":"node-info.war"}],"operation":"add","enabled":"true"}'

result=`curl -sS -X POST -d $content http://localhost:9990/management`

echo "Success!!!"
