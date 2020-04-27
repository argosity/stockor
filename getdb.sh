#!/bin/sh

scp nas@snoopy:/var/backups/dropoff/woodstock/stockor-saas.db.gz /tmp/

gzip -c -d /tmp/stockor-saas.db.gz | psql stockor-saas_dev
