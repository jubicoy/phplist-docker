# phplist-docker
Phplist mailing system in Docker to be used with Openshift

Use the following environment variables to configure phplist

MYSQL_HOST

MYSQL_DATABASE

MYSQL_USER

MYSQL_PASSWORD

SMTP_HOST

SMTP_PORT

SMTP_USER

SMTP_PASS

Configure timezone with env variable TZ, e.g
TZ="Europe/Helsinki"

Add cron jobs with TASK_name variable, e.g
TASK_test="0 55 9 * * 1|/bin/bash /root/script.sh"
