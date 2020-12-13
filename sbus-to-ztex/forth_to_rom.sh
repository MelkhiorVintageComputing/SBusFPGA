!#/bin/bash

toke  prom.forth

od --endian=big -w4 -x prom.fc  | awk '{ print $2,$3"," }' >| /tmp/prom.hexa


cat /tmp/prom.hexa | sed -e 's/0/0000/g' -e 's/1/0001/g' -e 's/f/1111/g' -e 's/e/1110/g' -e 's/d/1101/g' -e 's/c/1100/g' -e 's/b/1011/g' -e 's/a/1010/g' -e 's/9/1001/g' -e 's/8/1000/g' -e 's/7/0111/g' -e 's/6/0110/g' -e 's/5/0101/g' -e 's/4/0100/g' -e 's/3/0011/g' -e 's/2/0010/g' -e 's/ //g' -e 's/\(.*\),/"\1",/g' | grep -n . | awk -F: '{ print $2" -- "$1 }'