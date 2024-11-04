# Docker Setup for Multiple Vite Apps

Assume you have two Vite projects in the following directory structure:
```
root-directory
├── coffee-delivery
│ ├── Dockerfile
│ ├── docker-compose.yml
│ ├── vite.config.js
│ └── ...
├── food-delivery
│ ├── Dockerfile
│ ├── docker-compose.yml
│ ├── vite.config.js
│ └── ...
├── start-all.sh
└── stop-all.sh

```

## 1. Dockerfile (Per App)

Each app can use the same Dockerfile template, so create a Dockerfile in both coffee-delivery and food-delivery directories:

```
# Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 5173  # This will be mapped differently in docker-compose

CMD ["npm", "run", "dev"]
```

## 2. Docker Compose Configuration for Multiple Apps

Create a docker-compose.yml in the root directory that defines services for each Vite app. Ensure each service has a unique name, port, and volume mapping.

```
# docker-compose.yml
version: "3.8"
services:
  coffee-delivery:
    build:
      context: ./coffee-delivery
      dockerfile: Dockerfile
    ports:
      - "5173:5173"  # Expose coffee-delivery on port 5173
    volumes:
      - ./coffee-delivery:/app  # Mount coffee-delivery source code for live updates
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true

  food-delivery:
    build:
      context: ./food-delivery
      dockerfile: Dockerfile
    ports:
      - "5174:5173"  # Expose food-delivery on port 5174 (maps to 5173 internally)
    volumes:
      - ./food-delivery:/app  # Mount food-delivery source code for live updates
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true
```

## 3. Vite Configuration for Each App

To ensure that hot reloading works in Docker, update the vite.config.js file in both coffee-delivery and food-delivery directories:

```js
// vite.config.js
import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    watch: {
      usePolling: true,
    },
    host: true,
    port: 5173,  // Each app will map to different external ports in docker-compose
  },
});
///

## 4. Start Script

Create a bash script start-all.sh in the root directory to start Vite apps:

```

#!/bin/bash

echo "Starting Vite applications..."

# Start each app individually

docker-compose up -d coffee-delivery
echo "coffee-delivery is running on http://localhost:5173"

docker-compose up -d food-delivery
echo "food-delivery is running on http://localhost:5174"

# Attach logs for apps in the foreground

docker-compose logs -f coffee-delivery food-delivery

```

Make the script executable:

```

chmod +x start-all.sh

```

### 5. Stop script

Create a bash script stop-all.sh in the root directory to stop both Vite apps:

```

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

````

Make the script executable:

```bash
chmod +x stop-all.sh

````

## Running the Apps

# 1. Run the start script:

```bash
./start-all.sh
```

# 2. Access the applications:

    coffee-delivery at http://localhost:5173
    food-delivery at http://localhost:5174

# 3. Changes to each app's files will be reflected instantly in the browser, as Docker mounts each app’s directory separately.

## Stopping the Apps

To stop both apps, run:

```bash
docker-compose down
```

This will stop and remove all running containers for both apps.
