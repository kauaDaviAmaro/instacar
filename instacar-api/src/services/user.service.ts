import bcrypt from 'bcryptjs';
import User from '../models/User';
import { IUser } from '../types';

export const createUser = async (userData: IUser) => {
  const { name, email, password, birthDate, phone, cep, number, gender } = userData;

  if (!name || !email || !password) {
    throw new Error('INVALID_USER');
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  return User.create({
    name,
    email,
    password: hashedPassword,
    birthDate,
    phone,
    cep,
    number,
    gender,
  });
};


export const getUserById = async (id: string) => {
  const user = await User.findOne({ where: { id } });

  if (!user) {
    throw new Error('INVALID_USER');
  }

  return user;
};

export const getUserByEmail = async (email: string) => {
  const user = await User.findOne({ where: { email } });

  if (!user) {
    throw new Error('INVALID_USER');
  }

  return user;
}