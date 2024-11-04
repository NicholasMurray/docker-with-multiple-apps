#!/bin/bash

# Stop Docker container in detached mode
docker-compose stop coffee-delivery

echo "coffee-delivery app has stopped running"

# Attach logs in the foreground
docker-compose logs -f
