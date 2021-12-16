# How To Change Docker's Root Directory

## Steps
1. Stopping Docker:
```
systemctl stop docker.socket
systemctl stop docker.service
```

2. Create service config directory and file:
```
mkdir -p /lib/systemd/system/docker.service.d
touch /lib/systemd/system/docker.service.d/docker-change-root-dir.conf
```

3. Using some text editor, save the below text in the file that was created in the previous step:
```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --data-root="/some/directory/to/save/docker/data"
```
Note: `ExecStart=` is required first as blank for some reason

4. Reload daeman and start the docker services: 
```
systemctl daemon-reload
systemctl start docker.socket
systemctl start docker.service
```

5. Check current Docker root directory: 
```
docker info|grep "Docker Root Dir"
```
