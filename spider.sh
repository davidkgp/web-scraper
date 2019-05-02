#!/usr/bin/env bash
rm -rf "$WORKINGDIR/tmp"
rm -rf "$WORKINGDIR/img"

if [ "$#" -ne 2 ]; then
   echo -e "\e[31m Illegal number of parameters,pass in the link and the depth to be scrapped respectively \e[0m"
   exit 1
fi

DEPTH=$2

VALUE=${DEPTH//[!0-9]/}



if [ $(( VALUE <= 1 )) == 1 ]; then
   echo -e "\e[31m Depth of traversal has to be more than 1 \e[0m"
   exit 1
fi



linkNavigateandFindImageLinks.sh $1 $DEPTH 0
