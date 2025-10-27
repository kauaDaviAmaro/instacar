// models/conversation.model.ts
import { DataTypes } from "sequelize";
import sequelize from "../config/db";

const Conversation = sequelize.define("Conversation", {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  user1Id: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  user2Id: {
    type: DataTypes.STRING,
    allowNull: false,
  },
}, {
  timestamps: true,
});

export default Conversation;
