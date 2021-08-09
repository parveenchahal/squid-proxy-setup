x=$(cat users | base64 -w 0)
files="users:$x"

x=$(cat proxy-ca.crt | base64 -w 0)
files="$files;proxy-ca.crt:$x"

x=$(cat proxy-ca.key | base64 -w 0)
files="$files;proxy-ca.key:$x"


c=$(cat squid.conf | base64 -w 0)

docker run -d --name squid-proxy --restart unless-stopped --net host --env SQUID_CONF=$c --env FILES=$files pchahal24/squid-proxy:latest
