#!/usr/bin/env bash
source ./util/util.sh
ROOTLINK=$1

DOMAIN_URL=$(getDomainRoot $ROOTLINK)
silentlog "Domain Url :$DOMAIN_URL"
silentlog "Root Url :$ROOTLINK"


curl $ROOTLINK 2>&1 | grep -o -E 'href="([^"#]+)"' | while read link
do
  silentlog "to be visited $link"
  if [[ $(hrefisAbsolute $link) == "yes" ]]; then
  	silentlog $link
  
  # elif [[ condition ]]; then

  # elif [[ condition ]]; then
  
  else
  	PART_LINK=${link##*=}
  	PART_LINK_WITHOUTQUOTES=$(getStringinBetweenDoubleQuotes $PART_LINK)
  	echo $PART_LINK
  	FINAL_LINK=$DOMAIN_URL$PART_LINK_WITHOUTQUOTES
  	echo $FINAL_LINK
  	  	#echo "$DOMAIN_URL$FINAL_LINK"
  fi
  
done
