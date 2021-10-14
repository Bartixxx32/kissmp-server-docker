

# KissMP Beam.NG Multiplayer Server Dockerized

[KissMP Website](https://kissmp.online)

[KissMP GitHub](https://github.com/TheHellBox/KISS-multiplayer)

We reccommend to run `docker-compose.yml` than `docker run` to have better control on your server


To gain your own config.json, we recommend to start the server binary on your system to generate `server_identifier`. but at bottom we gave the example config you can use 

***Dont forget to change `server_identifier` to somentig else!***

`config.json`
```json
{
  "server_name": "My KissMP Server",
  "description": "My Server Description",
  "map": "/levels/smallgrid/info.json",
  "max_players": 15,
  "tickrate": 60,
  "port": 3698,
  "max_vehicles_per_client": 5,
  "show_in_server_list": true,
  "server_identifier": "zYd\\3n#'JA"
}
```
*How to setup server*

 1. Make sure you have `docker` and `docker-compose` installed on your system!
 2. Put `config.json` and `docker-compose.yml` into your server directory
 3. If you want add mods or addons create folders in same directory as `step 2` name it `mods` or/and `addons`
 4. Edit `config.json` and `docker-compose.yml` to your preffer
 5. Start server by using `docker-compose up -d`
 6. Try to join and review if everything is working!
 7. To stop or restart server use `docker-compose down` or `docker-compose restart`

--- You can use [Portainer.io](http://portainer.io) to manage your server from browser

`docker-compose.yml`
```yaml
---
version: "3"
services:
  kissmp:
    image: bartixxx32/kissmpbase:latest
    ports:
      - "3698:3698/udp"
    restart: unless-stopped
    volumes:
      - ./config.json:/server/config.json
      - ./mods/:/server/mods/
      - ./addons/:/server/addons/
---
```
