# Description
A custom server for Super Mario Bros. 35 running inside a Docker container

# Big thanks to:
* [kinnay/SMB35](https://github.com/kinnay/SMB35)  - The original implementation for the custom server
 * [SMB35 Continued Interest Community](https://smb35server.com/) - Some folks still playing on and running a centralized custom server

# Instructions:
`docker-compose.yml`:
```
services:
  smb35server-docker:
    container_name: smb35server-docker
    image: ghcr.io/royaltongue/smb35server-docker:test
    environment:
      PUID: 1000 # Optional
      GUID: 1000 # Optional
      SERVER_ADDRESS: myveryownsmbserver.com # Not used yet
    hostname: smb35server-docker
    ports:
      - 20000:20000
      - 20001:20001
      - 20002:20002
    restart: unless-stopped
```
___

Then, access the Dashboard at https://localhost:20002

# Still to do:
  * Generate IPS patch to redirect game to custom server address
  
