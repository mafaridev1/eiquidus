#!/bin/sh

# Start cron daemon in background
crond &

# Hand off to CMD
exec "$@"
 
