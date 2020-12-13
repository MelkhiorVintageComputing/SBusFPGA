#!/bin/bash

C=$1

n=1

TEMPSCRIPT=/tmp/tempscript.sh

/bin/rm $TEMPSCRIPT

while read line; do
    P=`echo $line | sed -e 's/[\t ]*/ /' | awk '{ print $1 }'`
    F=`echo $line | sed -e 's/[\t ]*/ /' | awk '{ print $2 }'`
    P_l=`echo $P | sed -e 's/^\([ABCD]\)\([0-9]*\)/\1/'`
    P_n=`echo $P | sed -e 's/^\([ABCD]\)\([0-9]*\)/\2/'`
    CONN=''
    S_l=''
    O=-50000
    if test x$P_l == 'xA'; then
	S_l=a
	CONN=AB
	O=-1
    elif test x$P_l == 'xB'; then
	S_l=b
	CONN=AB
	O=0
    elif test x$P_l == 'xC'; then
	S_l=a
	CONN=CD
	O=-1
    elif test x$P_l == 'xD'; then
	S_l=b
	CONN=CD
	O=0
    fi
    if test x$S_l == 'x'; then
	echo "oups";
	exit -1;
    fi
    N=$((O+2*P_n))
    
    if test x$C == x$CONN; then
	echo "sed -i -e 's/Pin_${S_l}${P_n} ${S_l}${P_n} /$F $N /g' \$1" >> $TEMPSCRIPT
    fi
done < $2

echo "sed -i -e 's/Conn_02x32_Row_Letter_First/ZTEX_$C/g' \$1" >> $TEMPSCRIPT

chmod a+x $TEMPSCRIPT

/bin/cp -i $3 $4

$TEMPSCRIPT $4

