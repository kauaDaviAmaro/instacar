import express from 'express';
import { register, getUser, updateUser, getUserByIdHandler, getCurrentUserProfileHandler } from '../controllers/user.controller';
import authMiddleware from '../middlewares/Auth';

const router = express.Router();

router.put('/', authMiddleware, updateUser);
router.get('/profile', authMiddleware, getCurrentUserProfileHandler);
router.get('/:userId', authMiddleware, getUserByIdHandler);

/**
 * @swagger
 * /users/register:
 *   post:
 *     summary: Registra um novo usuário
 *     description: Cria um novo usuário com nome, e-mail, senha, foto de perfil, código de verificação, data de nascimento, telefone, CEP e número.
 *     tags:
 *       - Usuários
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nome:
 *                 type: string
 *                 example: João Silva
 *               email:
 *                 type: string
 *                 example: joao@email.com
 *               senha:
 *                 type: string
 *                 example: 123456
 *               fotoPerfil:
 *                 type: string
 *                 example: https://exemplo.com/foto.jpg
 *               verificationCode:
 *                 type: string
 *                 example: "ABC123"
 *               codeExpires:
 *                 type: number
 *                 example: 1712345678901
 *               birthDate:
 *                 type: string
 *                 example: "1990-01-01"
 *               phone:
 *                 type: string
 *                 example: "+5511999999999"
 *               cep:
 *                 type: string
 *                 example: "12345-678"
 *               number:
 *                 type: string
 *                 example: "123"
 *     responses:
 *       201:
 *         description: Usuário cadastrado com sucesso
 *       500:
 *         description: Erro ao cadastrar usuário
 */
router.post('/register', register);

/**
 * @swagger
 * /users/:
 *   get:
 *     summary: Obtém os dados do usuário autenticado
 *     description: Retorna informações do usuário autenticado com base no token JWT enviado.
 *     tags:
 *       - Usuários
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       200:
 *         description: Dados do usuário retornados com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Acesso autorizado"
 *                 user:
 *                   type: object
 *                   properties:
 *                     userId:
 *                       type: string
 *                       example: "123456"
 *       401:
 *         description: Token inválido ou não fornecido
 *       403:
 *         description: Acesso negado, sem token válido
 */
router.get('/', authMiddleware, getUser);

export default router;
