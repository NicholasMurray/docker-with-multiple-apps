import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    watch: {
      usePolling: true, // Needed for live reload in Docker
    },
    host: true,         // Make the server accessible externally
    port: 5173,
  },
});
