# How to configure Squid child proxy to connect to parent proxy
Squid utilizes HTTP CONNECT tunnel to foward the HTTPS request to the request host transparently from the clients point of view. Please read [here](https://wiki.squid-cache.org/Features/HTTPS#CONNECT_tunnel_through_Squid) for more info.

The instruction described here will be based on Squid version 3.5.x.

## Disclaimer
The instructions here are only ment to describe how to configure one or more Squid proxies for facilitating the commincation between client and the requested host. Using Squid out side the descibed intent to decrypting HTTPS tunnels without user consent or knowledge may violate ethical norms and may be illegal in your jurisdiction. Decrypting HTTPS tunnels constitutes a man-in-the-middle attack from the overall network security point of view. Make sure you understand what you are doing and that your decision makers have enough information to make wise choices.

## Steps
### Install Squid
See install instructions: [here](https://wiki.squid-cache.org/SquidFaq/InstallingSquid#How_do_I_install_Squid.3F)
Or see docker container version: [here](https://hub.docker.com/r/sameersbn/squid)

### Basic config setup
Squid out of the box comes with some preconfigurations. Here we will extract those presets and back update the origianl file.
The step should be done on both child and parent proxy hosts.

Enter the folowing:
```
cd /etc/squid
mv squid.conf squid.conf.bak
cat squid.conf.bak | grep -v "^#.*$" | sed ':begin;$!N;s/^\n$//;tbegin' > squid.conf
```
After run the above you shoud now have a backup file `squid.conf.bak` and a trimed down version of the original, `squid.conf`.

The file `squid.conf` should contain the following:
```
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT


http_access deny !Safe_ports

http_access deny CONNECT !SSL_ports

http_access allow localhost manager
http_access deny manager


http_access allow localhost

http_access deny all

http_port 3128

coredump_dir /var/spool/squid

refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .               0       20%     4320
```

All below configuration should be added to `squid.conf` after the line containing `http_access deny CONNECT !SSL_ports` on there respective hosts.

### Child Proxy Config
Create file `/etc/squid/allowed_domains.txt`. This file will contain all the allowed domain requet that will be fowarded to the parent proxy.

Example: (One domain per line)
```
my.domain.net
some.domain.com
```

Add the following to `squid.conf` file on the child host: (make sure to update the IPs/Host names to match your own.)
```
acl localnet_src src 192.168.1.0/24                             # Creates ACL for inbound source connection IPs 

acl allowed_domains dstdomain "/etc/squid/allowed_domains.txt"  # Creates ACL for outbound destination domains from external file
cache_peer 172.19.0.3 parent 3128 0 no-query default            # Defines a parent proxy, we disable cache query with ' 0 no-query'. Squid defaul port: 3128
cache_peer_access 172.19.0.3 allow allowed_domains              # Allows access for the domains in 'allowed_domains' ACL for the specified cache_peer (parrent proxy)
cache_peer_access 172.19.0.3 deny all                           # Denies access for all non specified domains
never_direct allow allowed_domains                              # Domains specifed in 'allowed_domains' ACL should be directed to cache_peer (parrent proxy)
never_direct deny all                                           # All domains not specifed should never be directed to cache_peer (parrent proxy)

http_access allow !allowed_domains                              # Allow HTTP(S) access for domains NOT(!) specifed in 'allowed_domains' ACL
http_access allow localnet_src                                  # Allow HTTP(S) access for inbound source connection IPs (may not be required)
```

### Parent Proxy Config
Add the following to `squid.conf` file on the parent host: (make sure to update the IPs/Host names to match your own.)
```
acl child_proxy src 172.19.0.2/24   # Create ACL for the specific child proxy
http_access allow child_proxy       # Allow HTTP(S) access for child proxy
```

### Start Parent and child proxies
Once configed start both parent and child proxies, starting with parents first.

You can test the connect by using the `curl` command with the `-x` option.

Example: `curl my.domain.net -x 172.19.0.2:3128`

If the command failes make sure you have your ports configured correctly, otherwise make sure the parent is reachable by the child.

## References
- https://www.rootusers.com/configure-squid-proxy-to-forward-to-a-parent-proxy/
- https://wiki.squid-cache.org/Features/HTTPS#CONNECT_tunnel_through_Squid
- https://wiki.squid-cache.org/SquidFaq