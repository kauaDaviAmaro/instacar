import { Model, DataTypes } from 'sequelize';
import sequelize from '../config/db';

export interface IRideFeedback {
    id?: number;
    rideId: string;
    userId: string;
    counterpartyId: string;
    counterpartyName: string;
    rating: number;
    seatCount: number;
    observations: string;
    from: string;
    to: string;
    createdAt?: Date;
    updatedAt?: Date;
}

export class RideFeedback extends Model<IRideFeedback> implements IRideFeedback {
    public id!: number;
    public rideId!: string;
    public userId!: string;
    public counterpartyId!: string;
    public counterpartyName!: string;
    public rating!: number;
    public seatCount!: number;
    public observations!: string;
    public from!: string;
    public to!: string;
    public readonly createdAt!: Date;
    public readonly updatedAt!: Date;
}

RideFeedback.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            primaryKey: true,
        },
        rideId: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        userId: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        counterpartyId: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        counterpartyName: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        rating: {
            type: DataTypes.INTEGER,
            allowNull: false,
            validate: {
                min: 1,
                max: 5,
            },
        },
        seatCount: {
            type: DataTypes.INTEGER,
            allowNull: false,
            validate: {
                min: 1,
                max: 10,
            },
        },
        observations: {
            type: DataTypes.TEXT,
            allowNull: false,
        },
        from: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        to: {
            type: DataTypes.STRING,
            allowNull: false,
        },
    },
    {
        sequelize,
        modelName: 'RideFeedback',
        tableName: 'ride_feedbacks',
        timestamps: true,
    }
);

export default RideFeedback;
