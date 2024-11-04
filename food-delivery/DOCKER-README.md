# Vite Docker Development Setup

This setup allows you to run a Vite app in a Docker container with hot reloading enabled, so changes to the project are immediately reflected in the running app.

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your machine.
- [Docker Compose](https://docs.docker.com/compose/install/) installed.

---

## Instructions

### 1. Create a Dockerfile

Set up a `Dockerfile` in your project directory with the following content:

```Dockerfile
# Dockerfile
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy project files (for production build)
COPY . .

# Expose the default Vite port
EXPOSE 5173

# Run Vite in development mode
CMD ["npm", "run", "dev"]
```

### 2. Set Up Docker Compose

Create a docker-compose.yml file in your project directory with this content to define services, volume mounting, and port mapping:

```Docker-compose
# docker-compose.yml
version: "3.8"
services:
  food-delivery:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "5173:5173"  # Map Vite's default port to the host
    volumes:
      - .:/app  # Sync host directory with container for live updates
      - /app/node_modules  # Avoid conflicts with host node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true  # Ensure file watching works properly
```

### 3. Create a Start Script

Create a bash script named start-docker.sh in the project directory to start Docker with docker-compose:

```
#!/bin/bash

# Start Docker container in detached mode
docker-compose up -d

echo "Vite app is running in development mode on http://localhost:5173"

# Attach logs in the foreground
docker-compose logs -f
```

#### Make the script executable

```
chmod +x start-docker.sh
```

### 4. Create a Stop Script

Create a bash script named stop-docker.sh in the project directory to stop Docker with docker-compose:

```
#!/bin/bash

# Stop Docker container in detached mode
docker-compose stop food-delivery

echo "food-delivery app has stopped running"

# Attach logs in the foreground
docker-compose logs -f
```

#### Make the script executable

```
chmod +x stop-docker.sh
```

### 5. Configure Vite for Hot Reloading

In vite.config.js, add the following configuration to ensure hot module replacement (HMR) works properly in a Docker environment:

```js
// vite.config.js
import { defineConfig } from "vite";

export default defineConfig({
  server: {
    watch: {
      usePolling: true, // Needed for live reload in Docker
    },
    host: true, // Make the server accessible externally
    port: 5173,
  },
});
```

### 6. Running the Application

To run the application in development mode:

Run the start script:

```bash
./start-docker.sh
```

Access the app in your browser at http://localhost:5173.

Any changes made to the project files will be reflected instantly in the browser, thanks to Docker’s volume mounting and Vite’s hot module replacement.

### 7. Stopping the Application

To stop the application in development mode:

Run the stop script:

```bash
./stop-docker.sh
```
