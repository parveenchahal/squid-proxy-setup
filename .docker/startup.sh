extract_file() {
    IFS=':' read -ra arr <<< "$1"
    name=${arr[0]}
    value=${arr[1]}
    echo $value | base64 -d > $name
}

IFS=';' read -ra files <<< "$FILES" 

for i in "${files[@]}"; do
    extract_file $i
done

echo $SQUID_CONF | base64 -d > "squid.conf"

/usr/local/squid/sbin/squid start -f squid.conf

echo "* * * * * /rotate_access_logs_and_cleanup.sh" | crontab -
service cron restart

tail -F /usr/local/squid/var/logs/access.log
