import { Sequelize, Dialect } from 'sequelize';

// Create a connection without specifying the database first
const envDialect = process.env.DB_DIALECT as Dialect | undefined;
const dialect: Dialect = envDialect ?? 'mysql';

const defaultPort = dialect === 'postgres' ? '5432' : '3306';
const defaultUser = dialect === 'postgres' ? 'postgres' : 'user';
const defaultPassword = dialect === 'postgres' ? 'postgres' : 'password';

const sequelizeWithoutDB = new Sequelize({
  dialect,
  logging: false,
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || defaultPort),
  username: process.env.DB_USER || defaultUser,
  password: process.env.DB_PASSWORD || defaultPassword,
  // For Postgres, connect to the default 'postgres' database to manage DB creation
  ...(dialect === 'postgres' ? { database: 'postgres' } : {}),
  retry: {
    max: 3,
    timeout: 5000,
  },
});

// Create the main sequelize instance with the database
const sequelize = new Sequelize({
  dialect,
  logging: false,
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || defaultPort),
  username: process.env.DB_USER || defaultUser,
  password: process.env.DB_PASSWORD || defaultPassword,
  database: process.env.DB_NAME || 'instacar',
  retry: {
    max: 3,
    timeout: 5000,
  },
});

export const initializeDatabase = async () => {
  try {
    console.log(`Attempting to connect to ${dialect} server...`);
    
    // First, connect without database to create it if it doesn't exist
    await sequelizeWithoutDB.authenticate();
    console.log(`✅ ${dialect} server connected successfully!`);
    
    // Create database if it doesn't exist
    const dbName = process.env.DB_NAME || 'instacar';
    console.log(`Creating database '${dbName}' if it doesn't exist...`);
    if (dialect === 'postgres') {
      const [rows] = await sequelizeWithoutDB.query(
        'SELECT 1 FROM pg_database WHERE datname = :dbName',
        { replacements: { dbName } }
      );
      const exists = Array.isArray(rows) && rows.length > 0;
      if (!exists) {
        await sequelizeWithoutDB.query(`CREATE DATABASE "${dbName}"`);
      }
    } else {
      // MySQL - create database if not exists
      await sequelizeWithoutDB.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\``);
    }
    console.log(`✅ Database '${dbName}' is ready!`);
    
    // Close the connection without database
    await sequelizeWithoutDB.close();
    
    // Now connect to the specific database
    console.log('Connecting to the specific database...');
    await sequelize.authenticate();
    console.log('✅ Database connected successfully!');
    
    // Import all models here to avoid circular dependencies
    const User = require('../models/User').default;
    const Conversation = require('../models/conversation.model').default;
    const Message = require('../models/message.model').default;
    const Carona = require('../models/carona').default;
    const SolicitacaoCarona = require('../models/solicitacao-carona').default;
    const RideFeedback = require('../models/ride-feedback.model').default;
    
    // Set up associations
    Conversation.hasMany(Message, { foreignKey: 'conversationId', as: 'Messages' });
    Message.belongsTo(Conversation, { foreignKey: 'conversationId', as: 'Conversation' });
    
    // Carona associations
    Carona.hasMany(SolicitacaoCarona, { foreignKey: 'caronaId', as: 'solicitacoes' });
    
    // Sync all models
    console.log('Synchronizing database models...');
    await User.sync({ alter: true });
    await Conversation.sync({ alter: true });
    await Message.sync({ alter: true });
    await Carona.sync({ alter: true });
    await SolicitacaoCarona.sync({ alter: true });
    await RideFeedback.sync({ alter: true });
    
    console.log('✅ Database synchronized successfully!');
    
    // Run seeders automatically in development
    if (process.env.NODE_ENV === 'development' || process.env.AUTO_SEED === 'true') {
      try {
        console.log('🌱 Running automatic database seeding...');
        const { runAllSeeders } = require('../seeders/index');
        await runAllSeeders();
        console.log('✅ Automatic seeding completed!');
      } catch (seedError) {
        console.warn('⚠️ Automatic seeding failed:', seedError);
        // Don't throw error here to avoid breaking the app startup
      }
    }
    
    console.log('🎉 Database initialization completed!');
  } catch (error) {
    console.error('❌ Error in database initialization:', error);
    
    // Provide helpful error messages for common issues
    if (error && typeof error === 'object' && 'code' in error) {
      const dbError = error as { code: string };
      if (dbError.code === 'ECONNREFUSED') {
        console.error('💡 Make sure the database server is running on the specified host and port.');
      } else if (dbError.code === 'ER_ACCESS_DENIED_ERROR') {
        console.error('💡 Check your database username and password.');
      } else if (dbError.code === 'ENOTFOUND') {
        console.error('💡 Check your database host configuration.');
      }
    }
    
    throw error; // Re-throw to handle the error in the calling code
  }
};

export default sequelize;
