# 1. Install docker
    https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
# 2. Run below to start a squid container
- # Create CA certificates (Required only for SSL-Proxy)
    ```
    CN="proxy-ca"
    
    openssl genrsa -out proxy-ca.key 4096
    openssl req -x509 -new -nodes -key proxy-ca.key -sha256 -subj "/C=US/ST=CA/CN=$CN" -days 1024 -out proxy-ca.crt
    ```
- # Create user (Required only for basic auth)
    Intall htpasswd if not already installed. Run `sudo apt install apache2-utils`
    ```
    htpasswd -c ./users <username>
    ```
- # Modify the files/squid.conf as per your requirement
- # Any file want to pass on to container and use in squid config
    Just place that file in `files` directory.<br>
    Those files can be accessed using `/files/<fileName>` inside container.
- # Custom command execution
    Some custom command can be executed through setup.sh script.<br>
    setup.sh script will be executed just before starting the squid proxy server.
- # Start proxy
    ```
    chmod +x start.sh
    ./start.sh
    ```
# 3. Configure below rules for transparent proxy
- # Enable ip forwarding
    open file "/etc/sysctl.conf" and uncomment below
    ```
    net.ipv4.ip_forward = 1
    ```
    ```
    sysctl -p /etc/sysctl.conf
    ```
- # Set ip table NAT rules
    ```
    inf=<interface name>
    http_proxy_port=<port>
    https_proxy_port=<port>
    
    sudo iptables -t nat -A PREROUTING -i $inf -p tcp --dport 80 -j REDIRECT --to-port $http_proxy_port
    sudo iptables -t nat -A PREROUTING -i $inf -p tcp --dport 443 -j REDIRECT --to-port $https_proxy_port
    sudo iptables -t nat -A POSTROUTING -o $inf -p tcp -j MASQUERADE
    ```
    Use `iptables-persistent` to persist these rules; `sudo apt-get install iptables-persistent`
