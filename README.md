# 1. Install docker
    https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
# 2. Run below in samples directory
- # Create CA certificates
    ```
    openssl genrsa -out proxy-ca.key 4096
    openssl req -x509 -new -nodes -key proxy-ca.key -sha256 -subj "/C=US/ST=CA/CN=proxy-ca" -days 1024 -out proxy-ca.crt
    ```

- # Create user
    Intall htpasswd if not already installed. Run `sudo apt install apache2-utils`
    ```
    sudo htpasswd -c ./user <username>
    ```
- # Modify the squid.conf as per your requirement
- # Start proxy
    ```
    chmod +x start.sh
    ./start.sh
    ```