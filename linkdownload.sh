#!/usr/bin/env bash
source ./util/util.sh
IMG_LINK=$1

#if file size is specified or else go for default size

if [[ "${@: -1}" == *--download-lower-limit=* ]]; then
	PASSED_PARAM="${@: -1}"
    MAX_FILE_SIZE_IN_BYTES="${PASSED_PARAM#*=}"
    DESTINATION_DIR_PARAM="${@: -2}"
else
    MAX_FILE_SIZE_IN_BYTES=8000000
    DESTINATION_DIR_PARAM="${@: -1}"
fi

silentlog $DESTINATION_DIR_PARAM

if [[ "$DESTINATION_DIR_PARAM" == *--destination-dir=* ]]; then
	PASSED_PARAM="${@: -2}"
    DESTINATION_DIR="${PASSED_PARAM#*=}"
    silentlog $DESTINATION_DIR
else
    DESTINATION_DIR=.
    silentlog $DESTINATION_DIR
fi



# get the name of the file after the last / in url
FILE_NAME_SAVED=${IMG_LINK##*/}

filterFileTypes $IMG_LINK
checkLastCommadExecuteAndExit "Cannot download $IMG_LINK"

$(curl -o "$DESTINATION_DIR/$FILE_NAME_SAVED" --max-filesize $MAX_FILE_SIZE_IN_BYTES $IMG_LINK) 
checkLastCommadExecute "Download failed" #> "$DESTINATION_DIR/$FILE_NAME_SAVED"
