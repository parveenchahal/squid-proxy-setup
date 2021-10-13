cd /files
/usr/local/squid/sbin/squid start -f squid.conf

echo "* * * * * /rotate_access_logs_and_cleanup.sh" | crontab -
service cron restart

tail -F /usr/local/squid/var/logs/access.log
