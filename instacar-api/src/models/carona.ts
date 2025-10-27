import { DataTypes, Model, Optional } from "sequelize";
import sequelize from "../config/db";
import Usuario from "./User";

interface CaronaAttributes {
  id: string;
  motoristaId: string;
  origem: string;
  destino: string;
  dataHora: string;
  vagas: number;
  status: "disponível" | "lotada" | "finalizada";
  origem_lat?: number;
  origem_lon?: number;
  destino_lat?: number;
  destino_lon?: number;
  observacao?: string;
  vagasDisponiveis?: number; // se você quiser rastrear isso separadamente
}

type CaronaCreationAttributes = Optional<CaronaAttributes, "id" | "status" | "origem_lat" | "origem_lon" | "destino_lat" | "destino_lon" | "observacao" | "vagasDisponiveis">;

class Carona extends Model<CaronaAttributes, CaronaCreationAttributes> implements CaronaAttributes {
  [x: string]: any;
  public id!: string;
  public motoristaId!: string;
  public origem!: string;
  public destino!: string;
  public dataHora!: string;
  public vagas!: number;
  public status!: "disponível" | "lotada" | "finalizada";
  public origem_lat?: number;
  public origem_lon?: number;
  public destino_lat?: number;
  public destino_lon?: number;
  public observacao?: string;
  public vagasDisponiveis?: number;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

Carona.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    motoristaId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    origem: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    destino: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    dataHora: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    vagas: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM("disponível", "lotada", "finalizada"),
      defaultValue: "disponível",
    },
    origem_lat: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },
    origem_lon: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },
    destino_lat: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },
    destino_lon: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },
    observacao: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    vagasDisponiveis: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  },
  {
    sequelize,
    modelName: "Carona",
    tableName: "Caronas",
  }
);

// 🔁 Relacionamento com o modelo Usuario
Carona.belongsTo(Usuario, {
  foreignKey: "motoristaId",
  as: "motorista",
});

// Relacionamento com solicitações (será definido após a importação do modelo)
// Carona.hasMany(SolicitacaoCarona, { foreignKey: "caronaId", as: "solicitacoes" });

export default Carona;
