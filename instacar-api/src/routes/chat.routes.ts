import { Router } from "express";
import { getOrCreateConversation, sendMessage, listUserConversations, getConversationMessages } from "../controllers/chat.controller";
import { authenticateToken } from "../middlewares/Auth";
import { IAuthRequest } from "../types";

const router = Router();

// Get or create conversation between two users
router.post("/conversation", authenticateToken, async (req: IAuthRequest, res) => {
  try {
    const { user2Id } = req.body;
    const user1Id = req.user?.userId;

    if (!user2Id) {
      res.status(400).json({ error: "user2Id is required" });
      return;
    }

    if (!user1Id) {
      res.status(401).json({ error: "User not authenticated" });
      return;
    }

    console.log(`mensagem de ${user1Id} para ${user2Id}`);

    const conversation = await getOrCreateConversation(user1Id, user2Id);
    res.json(conversation);
  } catch (error) {
    console.error("Error creating conversation:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Send a message
router.post("/message", authenticateToken, async (req: IAuthRequest, res) => {
  try {
    const { receiverId, message } = req.body;
    const senderId = req.user?.userId;

    if (!receiverId || !message) {
      res.status(400).json({ error: "receiverId and message are required" });
      return;
    }

    if (!senderId) {
      res.status(401).json({ error: "User not authenticated" });
      return;
    }

    const newMessage = await sendMessage(senderId, receiverId, message);
    res.json(newMessage);
  } catch (error) {
    console.error("Error sending message:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Get user's conversations
router.get("/conversations", authenticateToken, async (req: IAuthRequest, res) => {
  try {
    const userId = req.user?.userId;
    
    if (!userId) {
      res.status(401).json({ error: "User not authenticated" });
      return;
    }

    const conversations = await listUserConversations(userId);
    res.json(conversations);
  } catch (error) {
    console.error("Error fetching conversations:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Get messages from a conversation
router.get("/conversation/:conversationId/messages", authenticateToken, async (req: IAuthRequest, res) => {
  try {
    const { conversationId } = req.params;
    const messages = await getConversationMessages(conversationId, req.user?.userId);
    res.json(messages);
  } catch (error) {
    console.error("Error fetching messages:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
