### Update Fan Sensor Thresh values
```
ipmitool -I lan -U [USERNAME] -P [PASSWORD] -H [HOST_IP] sensor thresh [FAN_ID] lower 100 150 200
```
