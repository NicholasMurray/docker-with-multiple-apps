#!/bin/bash

echo "Stopping Vite applications..."

# Stop each app individually

docker-compose stop coffee-delivery
echo "coffee-delivery has been stopped."

docker-compose stop food-delivery
echo "food-delivery has been stopped."

# Optionally, remove stopped containers

docker-compose rm -f coffee-delivery food-delivery
echo "Stopped containers for coffee-delivery and food-delivery have been removed."
