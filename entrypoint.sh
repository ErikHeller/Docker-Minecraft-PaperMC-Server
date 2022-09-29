#!/bin/sh

java -Xms"$MEMORY_SIZE" -Xmx"$MEMORY_SIZE" "$JAVA_FLAGS" -jar /opt/minecraft/paper.jar nogui
