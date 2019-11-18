#!/bin/bash

zookeeper=zookeeper:2181
#zookeeper=ckzdd01lv.yodel.net:2181,ckzdd02lv.yodel.net:2181,ckzdd03lv.yodel.net:2181
#zookeeper=ckzsd01lv.yodel.net:2181,ckzsd02lv.yodel.net:2181,ckzsd03lv.yodel.net:2181
#zookeeper=ckzud01lv.yodel.net:2181,ckzud02lv.yodel.net:2181,ckzud03lv.yodel.net:2181
#zookeeper=ckzpd01lv.yodel.net:2181,ckzpd02lv.yodel.net:2181,ckzpd03lv.yodel.net:2181,ckzpd04lv.yodel.net:2181,ckzpd05lv.yodel.net:2181

docker exec broker \
  kafka-topics \
    --list \
    --zookeeper ${zookeeper}
