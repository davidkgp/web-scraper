#!/usr/bin/env bash
source ./util/util.sh



ROOTLINK=$1

DEPTH=${2//[!0-9]/}
CURRENT_DEPTH=${3//[!0-9]/}

#echo $(alreadVisited $ROOTLINK)

if [[ $(alreadVisited $ROOTLINK) == "no" && $(( CURRENT_DEPTH == DEPTH+1 )) == 0 ]]; then

  

	addToVisited $ROOTLINK
	createImgFolder
	
	DOMAIN_URL=$(getDomainRoot $ROOTLINK)
    silentlog "Domain Url :$DOMAIN_URL"
    silentlog "Root Url :$ROOTLINK"
    


    {(curl $ROOTLINK 2>&1 | grep -o -E 'href="([^"#]+)"') && (curl $ROOTLINK 2>&1 | grep -o -E "href='([^'#]+)'")} | while read hreflink
    do
      link=$(echo $hreflink | sed "s/'/\"/g")  
      
      silentlog "to be visited $link"
      if [[ $(hrefisAbsolute $link) == "yes" ]]; then
      	 LINK=${link##*=}
  	     LINK_WITHOUTQUOTES=$(getStringinBetweenDoubleQuotes $LINK)

         #echo "$LINK_WITHOUTQUOTES DEPTH:$CURRENT_DEPTH"
  	    


        if [[ $(isImgLink $LINK_WITHOUTQUOTES) == "no" ]]; then

        	#echo "$(isImgLink $LINK_WITHOUTQUOTES) : $LINK_WITHOUTQUOTES"
        	
        		linkNavigateandFindImageLinks.sh $LINK_WITHOUTQUOTES $DEPTH $(( CURRENT_DEPTH+1 ))
        	
        else
        	  silentlog "Image download $LINK_WITHOUTQUOTES"
        	
        		linkdownload.sh $LINK_WITHOUTQUOTES --destination-dir="$WORKINGDIR/img"
        	
        fi

      else
  	     PART_LINK=${link##*=}
  	     PART_LINK_WITHOUTQUOTES=$(getStringinBetweenDoubleQuotes $PART_LINK)
  	     FINAL_LINK=$DOMAIN_URL$PART_LINK_WITHOUTQUOTES

         #echo "$FINAL_LINK DEPTH:$CURRENT_DEPTH"
  	     #echo $FINAL_LINK

         if [[ $(isImgLink $FINAL_LINK) == "no" ]]; then

         	    #echo "$(isImgLink $FINAL_LINK) : $FINAL_LINK"
        	
        		 linkNavigateandFindImageLinks.sh $FINAL_LINK $DEPTH $(( CURRENT_DEPTH+1 ))
        	
         else
         	silentlog "Image download $FINAL_LINK"
         	
        	linkdownload.sh $FINAL_LINK --destination-dir="$WORKINGDIR/img" &
        	
         fi

  	     

  	  	#echo "$DOMAIN_URL$FINAL_LINK"
      fi
  
    done
fi


