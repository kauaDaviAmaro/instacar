import { seedUsers } from './UserSeeder';
import { seedCaronas } from './CaronaSeeder';
import { seedConversations } from './ConversationSeeder';

export const runAllSeeders = async () => {
  try {
    console.log('🚀 Starting database seeding...');
    console.log('=====================================');
    
    // Run seeders in order (respecting dependencies)
    await seedUsers();
    await seedCaronas();
    await seedConversations();
    
    console.log('=====================================');
    console.log('🎉 All seeders completed successfully!');
  } catch (error) {
    console.error('❌ Error running seeders:', error);
    throw error;
  }
};

// Export individual seeders for selective seeding
export { seedUsers, seedCaronas, seedConversations };
