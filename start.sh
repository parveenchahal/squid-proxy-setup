docker run -d --name squid-proxy -v /etc/ssl/certs:/etc/ssl/certs -v $(pwd)/files:/files --restart unless-stopped --net host pchahal24/squid-proxy:latest
