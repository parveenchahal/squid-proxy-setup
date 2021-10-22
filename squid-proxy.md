Run squid on ubuntu as a docker container.

# Installation

## 1. Install docker

Follow the steps from https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04

## 2. Create or Update the files required by squid

- ### Create CA certificates (Required only for SSL-Proxy)
    We create an SSL certificate and add it to the squid container
    ```bash
    CN="proxy-ca"
    openssl genrsa -out proxy-ca.key 4096
    openssl req -x509 -new -nodes -key proxy-ca.key -sha256 -subj "/C=US/ST=CA/CN=$CN" -days 1024 -out proxy-ca.crt
    ```
    `proxy-ca.crt` is the SSL certificate that will be required to be truted by the clients who want to use SSL proxy.

- ### Create user credentials (Required only for basic auth)
    For configuring basic auth, i.e., [NCSA auth][1]:<br/>
    Intall htpasswd if not already installed.
    ```bash
    sudo apt install apache2-utils
    ```

    Create the password file and save it inside files/
    ```bash
    # $username, $password will have to be supplied
    # to authenticate proxy server
    htpasswd -c ./files/usercreds $username -i $password
    ```
- ### Modify the files/squid.conf as per your requirement

- ### Any file want to pass on to container and use in squid config
    Just place that file in `files` directory.<br>
    Those files can be accessed using `/files/<fileName>` inside container.

- ### Start proxy
    ```bash
    chmod +x start.sh
    ./start.sh
    ```

- ### View the access logs
    ```bash
    chmod +x tail_access_logs.sh
    ./tail_access_logs.sh
    ```

- ### Stop proxy server
    This will stop and remove the docker container
    ```bash
    chmod +x stop.sh
    ./stop.sh
    ```

## 3. Configure below rules for transparent proxy

The machine where we configure transparent proxy will have to be used
as the default gateway for the clients using transparent proxy.
We have to make this VM act as a router by enabling NAT.

- ### Enable ip forwarding
    open file "/etc/sysctl.conf" and uncomment below
    ```
    net.ipv4.ip_forward = 1
    ```
    Reload sysctl
    ```bash
    sudo sysctl -p /etc/sysctl.conf
    ```

- ### Set ip table NAT rules
    Check out this [tutorial][2] to get an idea of NAT and iptables.
    We are redirecting all the http and https traffic to the squid proxy server.
    ```bash
    # $iface : The interface connected to the private network. eg: eth0
    # $http_proxy_port = The proxy port for http (non-SSL proxy). eg: 3128
    # $https_proxy_port = The proxy port for https (SSL proxy). eg: 3129
    
    sudo iptables -t nat -A PREROUTING -i $iface -p tcp --dport 80 -j REDIRECT --to-port $http_proxy_port
    sudo iptables -t nat -A PREROUTING -i $iface -p tcp --dport 443 -j REDIRECT --to-port $https_proxy_port
    sudo iptables -t nat -A POSTROUTING -o $iface -p tcp -j MASQUERADE
    ```
    Use `iptables-persistent` to persist these rules; `sudo apt-get install iptables-persistent`

[1]: http://en.wikipedia.org/wiki/NCSA_HTTPd
[2]: https://www.karlrupp.net/en/computer/nat_tutorial
