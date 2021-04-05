x=$(cat users | base64 -w 0)
files="users:$x"

x=$(cat proxy-ca.crt | base64 -w 0)
files="$files;proxy-ca.crt:$x"

x=$(cat proxy-ca.key | base64 -w 0)
files="$files;proxy-ca.key:$x"


c=$(cat squid.conf | base64 -w 0)

sudo docker run -d -p 3128:3128 -p 3129:3129 --env SQUID_CONF=$c --env FILES=$files pchahal24/squid-proxy:latest
