#!/bin/bash

# Stop Docker container in detached mode
docker-compose stop food-delivery

echo "food-delivery app has stopped running"

# Attach logs in the foreground
docker-compose logs -f
