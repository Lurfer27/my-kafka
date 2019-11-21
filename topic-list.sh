#!/bin/bash

# Loop optional arguments
topicList=()
while :; do
	case $1 in
		-t|--topic)
			if [ "$2" ]; then
				topicList+=($2)
				shift
			else
				echo 'ERROR: "--topic" requires a non-empty argument'
				exit 1
			fi
			;;
		*)
			break
	esac
	shift
done

# Check argument count
if [ $# -ne 1 ]
then
	echo "Usage: topic-list [-t TOPIC]... PROPERTIES_FILE"
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

# Output arguments
echo $0 $1
for searchTopic in "${topicList[@]}"
do
	echo "searchTopic:" $searchTopic
done
echo "zookeeper:" ${zookeeper}

# Get list of all topics
docker exec broker \
  kafka-topics \
    --list \
    --zookeeper ${zookeeper} > topic-list.log

# Read file into array
mapfile -t < topic-list.log

# Find topics
rm found-topic-list.log
for foundTopic in "${MAPFILE[@]}"
do
 	foundTopicUpper=$(echo $foundTopic | tr [a-z] [A-Z])
	for searchTopic in "${topicList[@]}"
    do
		searchTopicUpper=$(echo $searchTopic | tr [a-z] [A-Z])
		if [[ $foundTopicUpper =~ $searchTopicUpper ]]; then
			echo $foundTopic >> found-topic-list.log
		fi
	done
done

# Sort File
sort found-topic-list.log > found-topic-list-sorted.log

# Read file into array
mapfile -t < found-topic-list-sorted.log

# Describe each topic
rm describe-topic-list.log
for topic in "${MAPFILE[@]}"
do
	docker exec broker \
  		kafka-topics \
    		--describe \
    		--topic ${topic} \
    		--zookeeper ${zookeeper} >> describe-topic-list.log
done

exit 0
