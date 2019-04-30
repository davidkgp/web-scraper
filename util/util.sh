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
