# How To Upgrade Protainer On Docker
Offical Wiki: https://docs.portainer.io/v/ce-2.11/start/upgrade/docker

1. Stop Protainer:
```
docker stop portainer
```
3. Delete Protainer container:
```
docker rm portainer
```
4. Pull latest Protainer image:
```
docker pull portainer/portainer-ce:latest
```
5. Run Protainer with latest version:
```
docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 \
  --name=portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```
6. Re-add to proxy network
