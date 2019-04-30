#!/usr/bin/env bash
silentlog(){
	if ! $SILENT; then
       echo $1
    fi
}

filterFileTypes(){

	local URL=$1


}

checkLastCommadExecute(){
	if [ $? -ne 0 ]; then
       echo -e "\e[31m $1 \e[0m"
    fi
}
