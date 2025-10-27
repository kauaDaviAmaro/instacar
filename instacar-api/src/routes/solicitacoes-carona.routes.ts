import { Router } from "express";
import solicitacaoCaronaController from "../controllers/solicitacao-carona.controller";
import authMiddleware from "../middlewares/Auth";

const solicitacoesCaronaRoutes = Router();

/**
 * @swagger
 * /solicitacoes-carona:
 *   post:
 *     summary: Solicitar uma carona
 *     tags: [Solicitações de Carona]
 *     security:
 *       - BearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               caronaId:
 *                 type: string
 *                 description: ID da carona
 *               mensagem:
 *                 type: string
 *                 description: Mensagem opcional para o motorista
 *             required:
 *               - caronaId
 *     responses:
 *       201:
 *         description: Solicitação criada com sucesso
 *       400:
 *         description: Dados inválidos ou carona não disponível
 *       401:
 *         description: Usuário não autenticado
 *       404:
 *         description: Carona não encontrada
 *
 * /solicitacoes-carona/minhas:
 *   get:
 *     summary: Obter minhas solicitações enviadas
 *     tags: [Solicitações de Carona]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de solicitações enviadas
 *       401:
 *         description: Usuário não autenticado
 *
 * /solicitacoes-carona/recebidas:
 *   get:
 *     summary: Obter solicitações recebidas (para motoristas)
 *     tags: [Solicitações de Carona]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de solicitações recebidas
 *       401:
 *         description: Usuário não autenticado
 *
 * /solicitacoes-carona/{id}/responder:
 *   put:
 *     summary: Responder uma solicitação (aceitar/rejeitar)
 *     tags: [Solicitações de Carona]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID da solicitação
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [aceita, rejeitada]
 *                 description: Status da resposta
 *             required:
 *               - status
 *     responses:
 *       200:
 *         description: Solicitação respondida com sucesso
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Usuário não autenticado
 *       403:
 *         description: Sem permissão para responder esta solicitação
 *       404:
 *         description: Solicitação não encontrada
 *
 * /solicitacoes-carona/{id}/cancelar:
 *   put:
 *     summary: Cancelar uma solicitação
 *     tags: [Solicitações de Carona]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID da solicitação
 *     responses:
 *       200:
 *         description: Solicitação cancelada com sucesso
 *       400:
 *         description: Solicitação não pode ser cancelada
 *       401:
 *         description: Usuário não autenticado
 *       403:
 *         description: Sem permissão para cancelar esta solicitação
 *       404:
 *         description: Solicitação não encontrada
 */

// Solicitar uma carona
solicitacoesCaronaRoutes.post("/", authMiddleware, solicitacaoCaronaController.solicitarCarona);

// Obter minhas solicitações enviadas
solicitacoesCaronaRoutes.get("/minhas", authMiddleware, solicitacaoCaronaController.getMinhasSolicitacoes);

// Obter solicitações recebidas (para motoristas)
solicitacoesCaronaRoutes.get("/recebidas", authMiddleware, solicitacaoCaronaController.getSolicitacoesRecebidas);

// Responder uma solicitação (aceitar/rejeitar)
solicitacoesCaronaRoutes.put("/:solicitacaoId/responder", authMiddleware, solicitacaoCaronaController.responderSolicitacao);

// Cancelar uma solicitação
solicitacoesCaronaRoutes.put("/:solicitacaoId/cancelar", authMiddleware, solicitacaoCaronaController.cancelarSolicitacao);

export default solicitacoesCaronaRoutes;
