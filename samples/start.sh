x=$(cat users | base64 -w 0)
files="users:$x"

x=$(cat proxy-ca.crt | base64 -w 0)
files="$files;proxy-ca.crt:$x"

x=$(cat proxy-ca.key | base64 -w 0)
files="$files;proxy-ca.key:$x"


c=$(cat squid.conf | base64 -w 0)

docker run -d --name squid-proxy -p 3128:3128 -p 3129:3129 -p 3130:3130 -p 3131:3131 --env SQUID_CONF=$c --env FILES=$files pchahal24/squid-proxy:latest
