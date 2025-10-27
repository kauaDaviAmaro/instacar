import { Request, Response } from 'express';
import Feedback from '../models/feedback.model';
import RideFeedback from '../models/ride-feedback.model';

export const submitFeedback = async (req: Request, res: Response): Promise<void> => {
    const { name, email, rating, comment, rideId, seatCount, counterpartyId, counterpartyName, from, to, userId } = req.body;

    // Se tem rideId, é uma avaliação de carona
    if (rideId) {
        if (!rideId || !userId || !counterpartyId || !counterpartyName || !rating || !seatCount || !comment || !from || !to) {
            res.status(400).json({ error: 'Campos obrigatórios para avaliação de carona não preenchidos' });
            return;
        }
        
        try {
            await RideFeedback.create({
                rideId,
                userId,
                counterpartyId,
                counterpartyName,
                rating,
                seatCount,
                observations: comment,
                from,
                to,
            });
            
            res.status(200).json({ message: 'Avaliação de carona enviada com sucesso' });
            return;
        } catch (error) {
            console.error('Erro ao salvar avaliação de carona:', error);
            res.status(500).json({ error: 'Erro ao salvar avaliação de carona no banco de dados' });
            return;
        }
    }

    // Feedback geral (comportamento original)
    if (!name || !email || !rating) {
        res.status(400).json({ error: 'Campos obrigatórios não preenchidos' });
        return;
    }
    
    try {
        await Feedback.create({ name, email, rating, comment });
        res.status(200).json({ message: 'Feedback enviado com sucesso' });
    } catch (error) {
        console.error('Erro ao salvar feedback:', error);
        res.status(500).json({ error: 'Erro ao salvar feedback no banco de dados' });
    }
};

export const getRideFeedbacks = async (req: Request, res: Response): Promise<void> => {
    try {
        const { userId } = req.params;
        
        const feedbacks = await RideFeedback.findAll({
            where: { userId },
            order: [['createdAt', 'DESC']],
        });
        
        res.status(200).json(feedbacks);
    } catch (error) {
        console.error('Erro ao buscar avaliações:', error);
        res.status(500).json({ error: 'Erro ao buscar avaliações' });
    }
};