#!/bin/sh

if [ "$DATABASE" = "postgres" ]; then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
        sleep 0.1
    done

    echo "PostgreSQL started"
fi

# Run Django setup commands
python manage.py makemigrations --no-input
python manage.py migrate --no-input
python manage.py collectstatic --no-input --clear
# python manage.py createsuperuser --no-input

# Start crontab
echo "Starting cron service..."
service cron start

# Tail log files to keep the container running
cron_log="/var/log/cron.log"
touch $cron_log
tail -f $cron_log &
exec "$@"
