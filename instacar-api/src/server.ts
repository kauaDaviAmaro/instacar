import dotenv from 'dotenv';
dotenv.config();

import { app, server } from './app';
import { initializeDatabase } from './config/db';
import { setupSwagger } from './config/swagger';

const PORT = process.env.PORT || 3000;

// Initialize database before starting the server
initializeDatabase().then(() => {
  setupSwagger(app);
  
  server.listen(PORT, () => {
    console.log(`Server running in http://localhost:${PORT}`);
  });
}).catch((error) => {
  console.error('Failed to initialize database:', error);
  process.exit(1);
});
