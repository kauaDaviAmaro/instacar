import { Request, Response } from 'express';
import {
  authenticateUser,
  createRecoveryCode,
  resetUserPassword,
  verifyCode,
} from '../services/auth.service';
import { MESSAGES } from '../utils/messages';
import { sendEmail } from '../services/email.service';

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, senha } = req.body;
    const token = await authenticateUser(email, senha);

    res.json({ message: MESSAGES.AUTH.LOGIN_SUCCESS, token });
  } catch (error: any) {
    if (error.message === 'INVALID_CREDENTIALS' || error.message === 'INVALID_USER') {
      res.status(401).json({ message: MESSAGES.AUTH.INVALID_CREDENTIALS });
      return;
    }
    console.error('Error authenticating user:', error);
    res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR, error });
  }
};

export const sendRecoveryCode = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { email } = req.body;

    const verificationCode = await createRecoveryCode(email);
    if (!verificationCode) {
      res.status(404).json({ message: MESSAGES.USER.NOT_FOUND });
      return;
    }

    await sendEmail(
      email,
      MESSAGES.EMAIL.SUBJECT,
      `Seu código de verificação é: ${verificationCode}`
    );
    res.json({ message: MESSAGES.EMAIL.SUCCESS });
  } catch (error: any) {
    console.error('Error sending recovery code:', error);
    if (error.message === 'USER_NOT_FOUND') {
      res.status(404).json({ message: MESSAGES.USER.NOT_FOUND });
      return;
    }
    res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR, error });
  }
};

export const verifyRecoveryCode = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, code } = req.body;

    const isValid = await verifyCode(email, code);

    if (!isValid) {
      res.status(400).json({ message: MESSAGES.GENERAL.UNAUTHORIZED });
      return;
    }

    res.json({ message: MESSAGES.AUTH.RESET_CODE_SUCCESS });
  } catch (error: any) {
    res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR, error });
  }
};

export const resetPassword = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { email, code, newPassword } = req.body;

  const isValid = await verifyCode(email, code);

  if (!isValid) {
    res.status(400).json({ message: MESSAGES.GENERAL.UNAUTHORIZED });
    return;
  }

  const success = await resetUserPassword(email, newPassword);
  if (!success) {
    res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR });
    return;
  }

  res.json({ message: MESSAGES.AUTH.RESET_PASSWORD_SUCCESS });
};
