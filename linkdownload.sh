#!/usr/bin/env bash
IMG_LINK=$1

#if file size is specified or else go for default size

if [[ "${@: -1}" == *--download-lower-limit=* ]]; then
	PASSED_PARAM="${@: -1}"
    MAX_FILE_SIZE_IN_BYTES="${PASSED_PARAM#*=}"
    #echo $MAX_FILE_SIZE_IN_BYTES
else
    MAX_FILE_SIZE_IN_BYTES=8000000
    #echo $MAX_FILE_SIZE_IN_BYTES
fi

if [[ "${@: -2}" == *--destination-dir=* ]]; then
	PASSED_PARAM="${@: -2}"
    DESTINATION_DIR="${PASSED_PARAM#*=}"
    echo $MAX_FILE_SIZE_IN_BYTES
else
    DESTINATION_DIR=.
fi



# get the name of the file after the last / in url
FILE_NAME_SAVED=${IMG_LINK##*/}
curl --max-filesize $MAX_FILE_SIZE_IN_BYTES $IMG_LINK > "$DESTINATION_DIR/$FILE_NAME_SAVED"
