#!/bin/bash

# Check argument count
if [ $# -ne 1 ]
then
	echo "Usage: topic-list PROPERTIES_FILE"
	exit 1
fi

# Set variables via PROPERTIES_FILE if it exists
if [ -f $1 ]
then
	source $1
fi

# Ensure zookeeper set
if [ -z ${zookeeper} ]
then
	echo "Usage: topic-list PROPERTIES_FILE"
	echo "zookeeper must be given"
	exit 1
fi

echo $0 $1
echo "zookeeper:" ${zookeeper}

docker exec broker \
  kafka-topics \
    --list \
    --zookeeper ${zookeeper} > topic-list.log

exit 0
