import { initializeDatabase } from '../config/db';

async function syncDatabase() {
  try {
    console.log('🔄 Starting database synchronization...');
    await initializeDatabase();
    console.log('✅ Database synchronization completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Database synchronization failed:', error);
    process.exit(1);
  }
}

syncDatabase();
