import { Request, Response } from 'express';
import { IAuthRequest, IUser } from '../types';
import { createUser, getUserById as getUserByIdService } from '../services/user.service';
import { MESSAGES } from '../utils/messages';
import User from '../models/User';

export const register = async (
  req: Request<{}, {}, IUser>,
  res: Response
): Promise<void> => {
  try {
    console.log('Registering user:', req.body);
    const anyBody: any = req.body as any;
    const newUser = await createUser({
      name: anyBody.name ?? anyBody.nome,
      email: anyBody.email,
      password: anyBody.password ?? anyBody.senha,
      fotoPerfil: anyBody.fotoPerfil,
      verificationCode: anyBody.verificationCode,
      codeExpires: anyBody.codeExpires,
      birthDate: anyBody.birthDate,
      phone: anyBody.phone,
      cep: anyBody.cep,
      number: anyBody.number,
      gender: anyBody.gender,
    });
    res
      .status(201)
      .json({ message: MESSAGES.USER.SUCCESS, userId: newUser.id });
  } catch (error: any) {
    if (error.message === 'INVALID_USER') {
      res.status(401).json({ message: MESSAGES.USER.INVALID_USER });
      return;
    }
    res.status(500).json({ message: MESSAGES.USER.ERROR });
  }
};

export const updateUser = async (req: IAuthRequest, res: Response) => {
  try {
    const userId = req.user?.userId; // A partir do middleware authMiddleware
    const updatedData = req.body;

    const updatedUser = await User.update(updatedData, {
      where: { id: userId },
    });

    res.status(200).json({ message: 'Usuário atualizado com sucesso', updatedUser });
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'Erro ao atualizar usuário' });
  }
};


export const getUser = async (
  req: IAuthRequest,
  res: Response
): Promise<void> => {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      res.status(401).json({ message: MESSAGES.USER.NOT_FOUND });
      return;
    }

    const user = await getUserByIdService(userId);

    res.json({
      user: {
        id: user?.id,
        name: user?.name,
        email: user?.email,
        fotoPerfil: user?.fotoPerfil,
      }
    });
  } catch (error) {
    console.error('Error getting user:', error);
    res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR });
  }
};

export const getUserByIdHandler = async (req: IAuthRequest, res: Response) => {
  try {
    const { userId } = req.params;
    
    if (!userId) {
      res.status(400).json({ error: "userId is required" });
      return;
    }

    const user = await User.findByPk(userId);
    
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    res.json({
      id: user.id,
      name: user.name,
      email: user.email,
      fotoPerfil: user.fotoPerfil,
      phone: user.phone,
      birthDate: user.birthDate,
      cep: user.cep,
      number: user.number,
      gender: user.gender,
      tipoVeiculo: user.tipoVeiculo,
      modeloVeiculo: user.modeloVeiculo,
      corVeiculo: user.corVeiculo,
      placa: user.placa,
    });
  } catch (error) {
    console.error("Error fetching user by ID:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const getCurrentUserProfileHandler = async (req: IAuthRequest, res: Response) => {
  try {
    const userId = req.user?.userId;
    
    if (!userId) {
      res.status(401).json({ error: "User not authenticated" });
      return;
    }

    const user = await User.findByPk(userId);
    
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    res.json({
      id: user.id,
      name: user.name,
      email: user.email,
      fotoPerfil: user.fotoPerfil,
      phone: user.phone,
      birthDate: user.birthDate,
      cep: user.cep,
      number: user.number,
      gender: user.gender,
      tipoVeiculo: user.tipoVeiculo,
      modeloVeiculo: user.modeloVeiculo,
      corVeiculo: user.corVeiculo,
      placa: user.placa,
    });
  } catch (error) {
    console.error("Error fetching current user profile:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};