# Docker Minecraft PaperMC Server

Dockerized Minecraft server for 1.18, 1.17 and upcoming versions using the [PaperMC](https://papermc.io).
When building an image from the provided Dockerfile, the latest version of the PaperMC Minecraft server will be retrieved from the [PaperMC API v2](https://papermc.io/api/docs/swagger-ui).

## Requirements

* Docker
* docker-compose  

## Starting the Minecraft Server
To start the server execute the command:
```shell script
docker-compose up -d
```
This will start a docker container with the name `paper_minecraft` in the background.
When starting, the current build of the selected version of the PaperMC server will be downloaded and executed.

The version of the minecraft server can be changed by changing the environment variable `MC_VERSION` in `docker-compose.yml`.

### Updating the Minecraft Server

Edit the `MC_VERSION` variable in `docker-compose.yml` to contain the desired minecraft server version.
Check https://papermc.io/downloads to see which versions are currently available or execute 
```shell script
curl "https://papermc.io/api/v2/projects/paper"
```
in a terminal.

To update the server (and the docker image) re-build the image and restart the container with:

```shell script
docker-compose down
docker-compose build
docker-compose up -d
```

## Environment variables

The docker image built from `./Dockerfile` supports the following environment variables:

* `MC_VERSION`: Sets the target version of the minecraft server. Setting this value to `latest` always retrieves the latest available version of the PaperMC server before running.
    * *default:* `latest`
* `MEMORY_SIZE`: Memory size to be allocated for the server. Do not allocate more than 70% of your systems RAM for this container!
    * *default:* `3G`
* `JAVA_FLAGS`: Use custom flags for optimizing the java runtime. Please remember to include the `-Dcom.mojang.eula.agree=true` flag.
    * *default:*
      ```
      -Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true
      ```

## Working with volumes

Per default the `docker-compose.yml` uses the named volume *minecraft-data* to store data like world data.
Alternatively you can use a directory in the host system instead of a named volume for example:

```yaml
version: "3"

services:
  minecraft:
    build: ./
    container_name: "paper_minecraft"
    environment:
      MEMORY_SIZE: "3G"
    volumes:
      - /path/to/minecraft-data:/data
    ports:
      - 25565:25565
```

## Troubleshooting

Sometimes the Minecraft JAR does not recognize the `-Dcom.mojang.eula.agree=true` flag.
If that is the case, the server will stop with the message `You need to agree to the EULA in order to run the server. Go to eula.txt for more info.`.

To solve this edit the eula.txt in your minecraft-data volume and set `eula=true`. This might require root permissions when working with a directory as a volume.


## Credits

Forked from: https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server
