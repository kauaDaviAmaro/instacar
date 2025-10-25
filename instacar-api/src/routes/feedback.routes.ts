import { Router } from "express";
import { submitFeedback, getRideFeedbacks } from '../controllers/feedback.controller';

const router = Router();

/**
 * @swagger
 * /feedback:
 *   post:
 *     summary: Submit user feedback or ride evaluation
 *     tags:
 *       - Feedback
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "João Silva"
 *               email:
 *                 type: string
 *                 example: "joao@email.com"
 *               rating:
 *                 type: integer
 *                 example: 5
 *               comment:
 *                 type: string
 *                 example: "Ótimo serviço!"
 *               rideId:
 *                 type: string
 *                 example: "123"
 *               userId:
 *                 type: string
 *                 example: "user123"
 *               counterpartyId:
 *                 type: string
 *                 example: "driver456"
 *               counterpartyName:
 *                 type: string
 *                 example: "Maria Santos"
 *               seatCount:
 *                 type: integer
 *                 example: 3
 *               from:
 *                 type: string
 *                 example: "São Paulo"
 *               to:
 *                 type: string
 *                 example: "Rio de Janeiro"
 *     responses:
 *       200:
 *         description: Feedback submitted successfully
 *       400:
 *         description: Invalid input
 */
router.post('/', submitFeedback);

/**
 * @swagger
 * /feedback/rides/{userId}:
 *   get:
 *     summary: Get ride feedbacks for a user
 *     tags:
 *       - Feedback
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *         description: User ID
 *     responses:
 *       200:
 *         description: Ride feedbacks retrieved successfully
 *       500:
 *         description: Server error
 */
router.get('/rides/:userId', getRideFeedbacks);

export default router;
