// controllers/chat.controller.ts
import { Op, Model } from "sequelize";
import Conversation from "../models/conversation.model";
import Message from "../models/message.model";

export const getOrCreateConversation = async (user1Id: string, user2Id: string): Promise<Model & { id: string }> => {
  if (!user1Id || !user2Id) {
    throw new Error('user1Id and user2Id are required');
  }

  const [conversation] = await Conversation.findOrCreate({
    where: {
      [Op.or]: [
        { user1Id, user2Id },
        { user1Id: user2Id, user2Id: user1Id },
      ],
    },
    defaults: {
      user1Id,
      user2Id,
    },
  });

  return conversation as Model & { id: string };
};

export const sendMessage = async (senderId: string, receiverId: string, text: string) => {
  const conversation = await getOrCreateConversation(senderId, receiverId);

  const message = await Message.create({
    conversationId: conversation.id,
    senderId,
    message: text,
  });

  return message;
};

export const listUserConversations = async (userId: string) => {
  const conversations = await Conversation.findAll({
    where: {
      [Op.or]: [
        { user1Id: userId },
        { user2Id: userId },
      ],
    },
    include: [{
      model: Message,
      as: 'Messages',
      order: [['createdAt', 'DESC']],
      limit: 1,
    }],
  });

  return conversations;
};

export const getConversationMessages = async (conversationId: string, currentUserId?: string) => {
  const messages = await Message.findAll({
    where: {
      conversationId: conversationId,
    },
    order: [['createdAt', 'ASC']],
  });

  const result = messages.map(m => {
    const plain = m.get({ plain: true });
    return {
      ...plain,
      isMe: currentUserId ? String(plain.senderId) === String(currentUserId) : undefined,
    };
  });

  return result;
};