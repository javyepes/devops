#!/bin/bash
# vars
USERNAME=$1
TARGET_SERVER=$2
LOG_FILE=~/ssh-key-gen-sync.log

touch $LOG_FILE #create log file if it doesnt exist
(
if [ -z $USERNAME ] && [ $TARGET_SERVER ]
then
  echo invalid usage
  echo usage:./scriptname.sh username target_server
  echo e.g. ./scriptname.sh jyepes admin-centos-0001
  echo please rerun with the correct usage
  echo exit 0
  exit 0
elif [ -z $TARGET_SERVER ]
then
  echo invalid usage
  echo usage:./scriptname.sh username target_server
  echo e.g. ./scriptname.sh javyepes 10.100.100.1
  echo please rerun with the correct usage
  echo exit 0
  exit 0
else
  echo "create and send public key to target server"
  if [ -f ~/.ssh/id_rsa.pub ]
  then
    echo "Public Key exists"
    echo "copying public key to $TARGET_SERVER"
    cat ~/.ssh/id_rsa.pub | ssh -oStrictHostKeyChecking=no $USERNAME@$TARGET_SERVER "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod g-w ~/ && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
    echo "COMPLETE!"
  else
    echo "Public Key DOESNT exists"
    echo "Creating public key"
    ssh-keygen -t rsa -N ""
    echo "copying public key to $TARGET_SERVER"
    cat ~/.ssh/id_rsa.pub | ssh -oStrictHostKeyChecking=no $USERNAME@$TARGET_SERVER "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod g-w ~/ && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
    echo "COMPLETE!"
  fi
fi

)|tee -a $LOG_FILE