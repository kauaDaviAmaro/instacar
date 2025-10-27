import { Request } from "express";

export interface IUser {
  id?: string;
  name: string;
  email: string;
  password: string;
  fotoPerfil?: string;

  // Novos campos
  birthDate?: string;
  phone?: string;
  cep?: string;
  number?: string;

  // Campos de veículo
  gender?: string;
  tipoVeiculo?: string;
  modeloVeiculo?: string;
  corVeiculo?: string;
  placa?: string;

  verificationCode?: string;
  codeExpires?: number | null;
}

export interface ICarona {
  id?: string;
  motoristaId?: string;
  origem: string;
  destino: string;
  dataHora: string;
  vagas: number;
  status?: "disponível" | "lotada" | "finalizada";
  origem_lat?: number;
  origem_lon?: number;
  destino_lat?: number;
  destino_lon?: number;
}

export interface IMotorista {
  id?: string;
  usuarioId: string;
  cnh: string;
  tipoVeiculo: string;
  corVeiculo?: string;
  placa: string;
  verificado?: boolean;
}

export interface IAuthRequest extends Request {
  user?: { userId: string };
}

export interface IUserDTO {
  id: string;
  nome: string;
  email: string;
  fotoPerfil?: string;
}

export interface ICaronaDTO {
  id: string;
  motoristaId?: string;
  origem: string;
  destino: string;
  dataHora: string;
  vagas: number;
  status?: "disponível" | "lotada" | "finalizada";
  origem_lat?: number;
  origem_lon?: number;
  destino_lat?: number;
  destino_lon?: number;
}
