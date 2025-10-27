import Conversation from '../models/conversation.model';
import Message from '../models/message.model';
import User from '../models/User';

export const seedConversations = async () => {
  try {
    console.log('🌱 Seeding conversations and messages...');
    
    // Check if conversations already exist
    const existingConversations = await Conversation.count();
    if (existingConversations > 0) {
      console.log('✅ Conversations already exist, skipping conversation seeding');
      return;
    }

    // Get user IDs for creating conversations
    const users = await User.findAll();
    if (users.length < 5) {
      console.log('⚠️ Not enough users found (need at least 5), skipping conversation seeding');
      return;
    }

    // Create conversations between different users
    const conversations = [
      {
        user1Id: users[0].id!,
        user2Id: users[1].id!
      },
      {
        user1Id: users[0].id!,
        user2Id: users[2].id!
      },
      {
        user1Id: users[1].id!,
        user2Id: users[3].id!
      },
      {
        user1Id: users[2].id!,
        user2Id: users[4].id!
      }
    ];

    const createdConversations = await Conversation.bulkCreate(conversations);

    // Extract IDs in a type-safe way for TS (Model<any, any> doesn't expose 'id')
    const conversationIds = createdConversations.map((c: any) =>
      typeof c.get === 'function' ? c.get('id') : c.id
    );

    // Create sample messages for each conversation
    const messages = [
      // Conversation 1: João and Maria
      {
        conversationId: conversationIds[0],
        senderId: users[0].id!,
        message: 'Oi Maria! Vi que você tem uma carona para o aeroporto amanhã. Ainda tem vaga?'
      },
      {
        conversationId: conversationIds[0],
        senderId: users[1].id!,
        message: 'Oi João! Sim, ainda tenho 2 vagas disponíveis. Você quer uma?'
      },
      {
        conversationId: conversationIds[0],
        senderId: users[0].id!,
        message: 'Perfeito! Que horas você sai?'
      },
      {
        conversationId: conversationIds[0],
        senderId: users[1].id!,
        message: 'Saio às 8h do Shopping Iguatemi. Te mando o endereço exato'
      },

      // Conversation 2: João and Pedro
      {
        conversationId: conversationIds[1],
        senderId: users[2].id!,
        message: 'Eaí João! Vi que você tem carona para o centro. Posso pegar uma carona?'
      },
      {
        conversationId: conversationIds[1],
        senderId: users[0].id!,
        message: 'Claro Pedro! Mas é de moto, só cabe 1 passageiro'
      },
      {
        conversationId: conversationIds[1],
        senderId: users[2].id!,
        message: 'Tranquilo! Quando você sai?'
      },

      // Conversation 3: Maria and Ana
      {
        conversationId: conversationIds[2],
        senderId: users[3].id!,
        message: 'Oi Maria! Como foi a carona de ontem?'
      },
      {
        conversationId: conversationIds[2],
        senderId: users[1].id!,
        message: 'Foi ótima! Obrigada por perguntar. E você, como está?'
      },
      {
        conversationId: conversationIds[2],
        senderId: users[3].id!,
        message: 'Estou bem! Quer fazer uma carona juntas essa semana?'
      },

      // Conversation 4: Pedro and Carlos
      {
        conversationId: conversationIds[3],
        senderId: users[4].id!,
        message: 'Pedro, vi que você tem uma carona para o hospital. Ainda tem vaga?'
      },
      {
        conversationId: conversationIds[3],
        senderId: users[2].id!,
        message: 'Oi Carlos! Sim, ainda tenho 1 vaga. É para consulta médica?'
      },
      {
        conversationId: conversationIds[3],
        senderId: users[4].id!,
        message: 'Exato! Preciso ir amanhã às 14h'
      },
      {
        conversationId: conversationIds[3],
        senderId: users[2].id!,
        message: 'Perfeito! Te busco no metrô Fradique Coutinho às 13h30'
      }
    ];

    await Message.bulkCreate(messages);
    console.log('✅ Conversations and messages seeded successfully!');
  } catch (error) {
    console.error('❌ Error seeding conversations:', error);
    throw error;
  }
};
