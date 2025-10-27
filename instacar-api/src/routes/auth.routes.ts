import express from 'express';
import {
  login,
  resetPassword,
  verifyRecoveryCode,
  sendRecoveryCode,
} from '../controllers/auth.controller';

const router = express.Router();

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Autentica um usuário
 *     description: Verifica credenciais e retorna um token JWT.
 *     tags:
 *       - Autenticação
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 example: joao@email.com
 *               senha:
 *                 type: string
 *                 example: 123456
 *     responses:
 *       200:
 *         description: Login bem-sucedido
 *       401:
 *         description: Credenciais inválidas
 *       500:
 *         description: Erro no servidor
 */
router.post('/login', login);

/**
 * @swagger
 * /auth/forgot-password:
 *   post:
 *     summary: Envia código de recuperação de senha
 *     description: Envia um código de verificação para o e-mail do usuário.
 *     tags:
 *       - Autenticação
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 example: joao@email.com
 *     responses:
 *       200:
 *         description: Código enviado com sucesso
 *       404:
 *         description: Usuário não encontrado
 */
router.post('/forgot-password', sendRecoveryCode);

/**
 * @swagger
 * /auth/verify-code:
 *   post:
 *     summary: Verifica código de recuperação
 *     description: Confirma se o código enviado por e-mail é válido.
 *     tags:
 *       - Autenticação
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               code:
 *                 type: string
 *     responses:
 *       200:
 *         description: Código válido
 *       400:
 *         description: Código inválido ou expirado
 */
router.post('/verify-code', verifyRecoveryCode);

/**
 * @swagger
 * /auth/reset-password:
 *   post:
 *     summary: Redefine a senha do usuário
 *     description: Permite redefinir a senha após a verificação do código.
 *     tags:
 *       - Autenticação
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               code:
 *                 type: string
 *               newPassword:
 *                 type: string
 *     responses:
 *       200:
 *         description: Senha redefinida com sucesso
 *       400:
 *         description: Código inválido ou expirado
 *       500:
 *         description: Erro ao redefinir senha
 */
router.post('/reset-password', resetPassword);

export default router;
