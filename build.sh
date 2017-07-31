#!/bin/bash

export GOPATH=/usr/src/cron/vendor
cd /usr/src/cron
go get
go build -v -o /opt/cron
rm -rf /usr/src/cron/vendor/*