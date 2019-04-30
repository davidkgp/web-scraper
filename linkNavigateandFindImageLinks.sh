#!/usr/bin/env bash
source ./util/util.sh



ROOTLINK=$1


#echo $(alreadVisited $ROOTLINK)

if [[ $(alreadVisited $ROOTLINK) == "no" ]]; then


	addToVisited $ROOTLINK
	createImgFolder
	
	DOMAIN_URL=$(getDomainRoot $ROOTLINK)
    silentlog "Domain Url :$DOMAIN_URL"
    silentlog "Root Url :$ROOTLINK"
    


    curl $ROOTLINK 2>&1 | grep -o -E 'href="([^"#]+)"' | while read link
    do
      silentlog "to be visited $link"
      if [[ $(hrefisAbsolute $link) == "yes" ]]; then
      	 LINK=${link##*=}
  	     LINK_WITHOUTQUOTES=$(getStringinBetweenDoubleQuotes $LINK)
  	    echo $LINK_WITHOUTQUOTES

        if [[ $(isImgLink $LINK_WITHOUTQUOTES) == "no" ]]; then
        	(
        		linkNavigateandFindImageLinks.sh $LINK_WITHOUTQUOTES
        	)
        else
        	(
        		linkdownload.sh $LINK_WITHOUTQUOTES --destination-dir="$WORKINGDIR/img"
        	)
        fi

  	    
  	     
  
      #elif [[ condition ]]; then

      # elif [[ condition ]]; then
  
      else
  	     PART_LINK=${link##*=}
  	     PART_LINK_WITHOUTQUOTES=$(getStringinBetweenDoubleQuotes $PART_LINK)
  	     FINAL_LINK=$DOMAIN_URL$PART_LINK_WITHOUTQUOTES
  	     echo $FINAL_LINK

         if [[ $(isImgLink $FINAL_LINK) == "no" ]]; then
        	(
        		linkNavigateandFindImageLinks.sh $FINAL_LINK
        	)
         else
         	(
        	linkdownload.sh $FINAL_LINK --destination-dir="$WORKINGDIR/img"
        	)
         fi

  	     

  	  	#echo "$DOMAIN_URL$FINAL_LINK"
      fi
  
    done
fi


