import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import routes from "./routes/index.routes";
import { Server } from "socket.io";
import http from "http";
import { sendMessage } from "./controllers/chat.controller";

const app = express();

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

const users: { [userId: string]: string } = {};

io.on("connection", (socket) => {
  const userId = socket.handshake.query.userId as string;
  users[userId] = socket.id;

  console.log(`Usuário conectado: ${userId} (${socket.id})`);

  socket.on("sendMessage", async ({ senderId, receiverId, message }) => {
    try {
      const savedMessage = await sendMessage(senderId, receiverId, message);
      const receiverSocketId = users[receiverId];
      const senderSocketId = users[senderId];

      // Enviar para o destinatário
      if (receiverSocketId) {
        io.to(receiverSocketId).emit("receiveMessage", {
          senderId: savedMessage.get('senderId'),
          receiverId: receiverId,
          message: savedMessage.get('message'),
          createdAt: savedMessage.get('createdAt'),
        });
      }

      // Enviar de volta para o remetente (confirmação)
      if (senderSocketId) {
        io.to(senderSocketId).emit("messageSent", {
          senderId: savedMessage.get('senderId'),
          receiverId: receiverId,
          message: savedMessage.get('message'),
          createdAt: savedMessage.get('createdAt'),
        });
      }
    } catch (error) {
      console.error('Error sending message:', error);
      socket.emit("messageError", { error: "Failed to send message" });
    }
  });

  socket.on("disconnect", () => {
    delete users[userId];
    console.log(`Usuário desconectado: ${userId}`);
  });
});

app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

app.use("/api", routes);

export { app, server, io };
