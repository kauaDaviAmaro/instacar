import { DataTypes, Model } from 'sequelize';
import sequelize from '../config/db';
import { IUser } from '../types';

class User extends Model<IUser> implements IUser {
  id?: string;
  name!: string;
  email!: string;
  password!: string;
  fotoPerfil?: string;
  verificationCode?: string;
  codeExpires?: number | null;

  // Novos campos
  birthDate?: string;
  phone?: string;
  cep?: string;
  number?: string;

  // Campos de veículo
  gender?: string;
  tipoVeiculo?: string;
  modeloVeiculo?: string;
  corVeiculo?: string;
  placa?: string;
}

User.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    name: { type: DataTypes.STRING, allowNull: false },
    email: { type: DataTypes.STRING, allowNull: false, unique: true },
    password: { type: DataTypes.STRING, allowNull: false },
    fotoPerfil: { type: DataTypes.STRING },
    verificationCode: { type: DataTypes.STRING },
    codeExpires: { type: DataTypes.BIGINT },

    // Novos campos
    birthDate: { type: DataTypes.STRING },
    phone: { type: DataTypes.STRING },
    cep: { type: DataTypes.STRING },
    number: { type: DataTypes.STRING },

    // Campos de veículo
    gender: { type: DataTypes.STRING },
    tipoVeiculo: { type: DataTypes.STRING },
    modeloVeiculo: { type: DataTypes.STRING },
    corVeiculo: { type: DataTypes.STRING },
    placa: { type: DataTypes.STRING },
  },
  {
    sequelize,
    timestamps: true,
    modelName: 'User',
    tableName: 'Users'
  }
);

export default User;
