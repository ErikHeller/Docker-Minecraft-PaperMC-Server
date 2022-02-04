FROM azul/zulu-openjdk-alpine:17-jre

# Install dependencies
RUN apk add curl jq screen

# Target version of the minecraft server
ENV MC_VERSION=latest
# Memory size to be allocated for the server
ENV MEMORY_SIZE=3G
# Set flags for optimizing the java runtime
ENV JAVA_FLAGS="-Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"

WORKDIR /opt/minecraft

# Copy necessary scripts into docker image
COPY entrypoint.sh /opt/minecraft
COPY ./getpaperserver.sh /opt/minecraft
RUN chmod +x /opt/minecraft/entrypoint.sh /opt/minecraft/getpaperserver.sh

# Get current paper MC server
RUN /opt/minecraft/getpaperserver.sh ${MC_VERSION}

# Create volumes for external data (Server, World, Config...) and logs
VOLUME "/data"

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

WORKDIR /data

# Use non-root user for starting the server
RUN adduser -D minecraft
RUN chown minecraft:minecraft /data
USER minecraft

# Entrypoint
ENTRYPOINT ["/opt/minecraft/entrypoint.sh"]

