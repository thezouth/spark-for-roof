#!/bin/bash

AZURE_STORAGE_ACCOUNT_NAME=sparklingstorage
AZURE_STORAGE_ACCOUNT_PASSWORD="Gjs2UYGwRvI17qEMjeOiLQmqLT0OwxvofiyZ62PgpBb+mKNtcubuh2LEEoKOH42akS4HWFnR+wY/lWuDna7WbA=="
AZURE_STORAGE_SHARE=sparklingshare

sudo apt-get install -y cifs-utils

mkdir ./data

sudo mount -t cifs //${AZURE_STORAGE_ACCOUNT_NAME}.file.core.windows.net/${AZURE_STORAGE_SHARE} ./data \
    -o vers=3.0,username=${AZURE_STORAGE_ACCOUNT_NAME},password=${AZURE_STORAGE_ACCOUNT_PASSWORD},dir_mode=0777,file_mode=0777,serverino