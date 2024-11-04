#!/bin/bash

# Start both apps in detached mode

docker-compose up -d

echo "coffee-delivery is running on http://localhost:5173"
echo "food-delivery is running on http://localhost:5174"