import { DataTypes, Model, Optional } from "sequelize";
import sequelize from "../config/db";
import Usuario from "./User";
import Carona from "./carona";

interface SolicitacaoCaronaAttributes {
  id: string;
  caronaId: string;
  passageiroId: string;
  status: "pendente" | "aceita" | "rejeitada" | "cancelada";
  mensagem?: string;
  dataSolicitacao: Date;
}

type SolicitacaoCaronaCreationAttributes = Optional<SolicitacaoCaronaAttributes, "id" | "dataSolicitacao">;

class SolicitacaoCarona extends Model<SolicitacaoCaronaAttributes, SolicitacaoCaronaCreationAttributes> implements SolicitacaoCaronaAttributes {
  public id!: string;
  public caronaId!: string;
  public passageiroId!: string;
  public status!: "pendente" | "aceita" | "rejeitada" | "cancelada";
  public mensagem?: string;
  public dataSolicitacao!: Date;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

SolicitacaoCarona.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    caronaId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    passageiroId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM("pendente", "aceita", "rejeitada", "cancelada"),
      defaultValue: "pendente",
    },
    mensagem: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    dataSolicitacao: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    sequelize,
    modelName: "SolicitacaoCarona",
    tableName: "SolicitacoesCarona",
  }
);

// Relacionamentos
SolicitacaoCarona.belongsTo(Carona, { 
  foreignKey: "caronaId", 
  as: "carona" 
});

SolicitacaoCarona.belongsTo(Usuario, { 
  foreignKey: "passageiroId", 
  as: "passageiro" 
});

export default SolicitacaoCarona;
