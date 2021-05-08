# 1. Install docker
    https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
# 2. Run below in samples directory
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
- # Modify the squid.conf as per your requirement
- # Start proxy
    ```
    chmod +x start.sh
    ./start.sh
    ```
# 3. For transparent proxy set iptables rules
    inf=<interface name>
    http_proxy_port=<port>
    https_proxy_port=<port>
    
    sudo iptables -t nat -A PREROUTING -i $inf -p tcp --dport 80 -j REDIRECT --to-port $http_proxy_port
    sudo iptables -t nat -A PREROUTING -i $inf -p tcp --dport 443 -j REDIRECT --to-port $https_proxy_port
    sudo iptables --t nat -A POSTROUTING -o $inf -p tcp -j MASQUERADE
