#!/bin/bash

# Start Docker container in detached mode
docker-compose up -d

echo "coffee-delivery app is running in development mode on http://localhost:5173"

# Attach logs in the foreground
docker-compose logs -f
