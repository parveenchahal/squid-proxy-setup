docker run -d --name squid-proxy -v $(pwd)/files:/files --restart unless-stopped --net host pchahal24/squid-proxy:latest
