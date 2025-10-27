#!/usr/bin/env ts-node

import { initializeDatabase } from '../config/db';
import { runAllSeeders } from './index';

const main = async () => {
  try {
    console.log('🚀 Starting database initialization and seeding...');
    
    // Initialize database (create tables, etc.)
    await initializeDatabase();
    
    // Run all seeders
    await runAllSeeders();
    
    console.log('🎉 Database initialization and seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error during database initialization and seeding:', error);
    process.exit(1);
  }
};

// Run if this file is executed directly
if (require.main === module) {
  main();
}
