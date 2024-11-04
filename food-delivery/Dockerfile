# Dockerfile
FROM node:20-alpine

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
