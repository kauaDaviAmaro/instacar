import { Model, DataTypes } from 'sequelize';
import sequelize from '../config/db';

export interface IFeedback {
    name: string;
    email: string;
    rating: number;
    comment?: string;
}

export class Feedback extends Model<IFeedback> implements IFeedback {
    public name!: string;
    public email!: string;
    public rating!: number;
    public comment?: string;
}

Feedback.init(
    {
        name: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        email: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        rating: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
        comment: {
            type: DataTypes.STRING,
            allowNull: true,
        },
    },
    {
        sequelize,
        modelName: 'Feedback',
        tableName: 'feedbacks',
        timestamps: false,
    }
);

export default Feedback;