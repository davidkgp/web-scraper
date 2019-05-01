#!/usr/bin/env bash
silentlog(){
	if ! $SILENT; then
       echo $1
    fi
}

hrefisAbsolute(){

	local URL_href=$1
	local URL=${URL_href##*=}
	local protocol=${URL%%/*}

	if [[ $protocol == *"http:"*  ||  $protocol == *"https:"* ]]; then
		echo "yes"
	fi


}

filterFileTypes(){

	local URL=$1
	local val=$((${#URL}-1))
	local last_char=${URL:$val:1}
	# dont download if url ends with /
	if [[ "$last_char" == '/' ]]; then
		return 1
	fi

	local LINK_FILE_TYPE=${URL##*.}
    
    if [[ $FILE_TYPE == *"$LINK_FILE_TYPE"* ]]; then
        silentlog "$LINK_FILE_TYPE is filtered and cannot be downloaded!"
        return 1
    else
    	silentlog "$LINK_FILE_TYPE can be downloaded!"
    fi
	

}

# first parameter is the error message
checkLastCommadExecute(){
	if [ $? -ne 0 ]; then
       echo -e "\e[31m $1 \e[0m"
    fi
}

checkLastCommadExecuteAndExit(){
	if [ $? -ne 0 ]; then
       echo -e "\e[31m $1 \e[0m"
       exit 1
    fi
}

getDomainRoot(){
	local URL=$1
	local protocol=${URL%%/*}
	local HALF=${URL#*//}
	local domain=${HALF%%/*}
	echo "$protocol//$domain"
}

getStringinBetweenDoubleQuotes(){
	local value=$1
	local delim=$2

	local one=${value#*\"}
	local final=${one%\"*}
	echo $final

}

alreadVisited(){
	local url=$1

	if [ ! -f "$WORKINGDIR/tmp/visited.txt" ]; then
       echo "no"
    elif [[ -f "$WORKINGDIR/tmp/visited.txt" ]]; then
    	if grep -q $url "$WORKINGDIR/tmp/visited.txt" ; then
    		echo "yes"
    	else
    		echo "no"
    	fi
    	 
    fi
}

createVisited(){
	if [[ ! -d "$WORKINGDIR/tmp" ]]; then
		mkdir "$WORKINGDIR/tmp"
		touch "$WORKINGDIR/tmp/visited.txt"
	else
		if [ ! -f "$WORKINGDIR/tmp/visited.txt" ]; then
			touch "$WORKINGDIR/tmp/visited.txt"
		fi
	fi
	
}

createImgFolder(){
	if [[ ! -d "$WORKINGDIR/img" ]]; then
		mkdir "$WORKINGDIR/img"
	fi
	
}

addToVisited(){
	createVisited
	echo $1 >> "$WORKINGDIR/tmp/visited.txt"
}

isImgLink(){
	
	local URL=$1
	local val=$((${#URL}-1))
	local last_char=${URL:$val:1}
	# dont download if url ends with /
	if [[ "$last_char" == '/' ]]; then
		echo "no"
	else
		if [[ $IMG_FILE_TYPE != *"${URL##*/}"* ]]; then
			echo "no"
		elif [[ $IMG_FILE_TYPE != *"${URL##*.}"* ]]; then
			echo "no"
		fi
	fi

}


isImgBelowMinimumLength(){
  local URL=$1
  local MIN=100000

  local VAL=$(curl -sI $URL | grep -i "Content-Length")
  local SIZE=${VAL//[!0-9]/}
  local DECIDE=$(( SIZE < MIN ))

  if [[ $DECIDE == 1 ]] ; then
  	return 1
  else 
  	return 0
  fi

}

