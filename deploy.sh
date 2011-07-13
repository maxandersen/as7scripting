#!/usr/bin/bash

hash=`curl -F "file=@pastecode.war;type=application/octet-stream" http://localhost:9990/management/add-content | sed -e "s/.*\"BYTES_VALUE\".*\:.*\"\(.*\)\".*/\1/g"`

content='{"content":[{"hash":{"BYTES_VALUE":"'$hash'"}}],"address":[{"deployment":"pastecode.war"}],"operation":"add","enabled":"true"}'

curl -i -X POST -d $content http://localhost:9990/management