#!/bin/bash
 
MONGO_DATABASE="test"
APP_NAME="test"
BK_PATH="/home/vivek/Desktop/BK"
DB_SIZE_MIN_VALUE=22000

MONGO_HOST="127.0.0.1"
MONGO_PORT="27017"
TIMESTAMP=`date +%F-%H%M%S`
MONGODUMP_PATH="/usr/bin/mongodump"
BACKUPS_DIR="$BK_PATH/$APP_NAME"
BACKUP_NAME="$APP_NAME-$TIMESTAMP"
BACKUP_ZIP_NAME=$BACKUPS_DIR/$BACKUP_NAME.tgz
 
$MONGODUMP_PATH -d $MONGO_DATABASE
 
mkdir -p $BACKUPS_DIR
mv dump $BACKUP_NAME
tar -zcvf $BACKUP_ZIP_NAME $BACKUP_NAME
rm -rf $BACKUP_NAME

FILESIZE=$(stat -c%s "$BACKUP_ZIP_NAME")

if [ $FILESIZE -lt $DB_SIZE_MIN_VALUE ]; then
    echo "WrongDump"
    exit 1
fi 

for filename in $BACKUPS_DIR/*; do
    if [ "$filename" != "$BACKUP_ZIP_NAME" ]; then
        rm -rf $filename
    fi
done