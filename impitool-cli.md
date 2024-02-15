### Build From Source
#### Requirements
1. Linux system or subsystem on windows
2. Clone https://github.com/ipmitool/ipmitool
3. Install systeam build dependencies and requirements:
```
sudo apt update
sudo apt upgrade
sudo apt install q++               #Opsional ?
sudo apt install build-essential
sudo apt install autotools-dev automake pkg-config libtool libreadline-dev
```
#### Build
Wiki: https://github.com/ipmitool/ipmitool/wiki
```
cd ipmitool
autoupdate
./bootstrap
./configure
make
make install DESTDIR=/tmp/package-ipmitool
```

### Install pre compiled
```
sudo apt install ipmitool
```
### Update Fan Sensor Thresh values
```
ipmitool -I lan -U [USERNAME] -P [PASSWORD] -H [HOST_IP] sensor thresh [FAN_ID] lower 100 150 200
```
#### Usefull:
- https://forums.servethehome.com/index.php?resources/supermicro-x9-x10-x11-fan-speed-control.20/
