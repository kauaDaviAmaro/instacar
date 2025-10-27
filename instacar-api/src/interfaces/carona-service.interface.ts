import Carona from "../models/carona";

export interface ICaronaService {
  getAllCaronas(): Promise<Carona[]>;
  createCarona(data: CreateCaronaDTO): Promise<Carona>;
  getCaronaById(id: string): Promise<Carona | null>;
  listCaronas(filter?: CaronaFilter): Promise<Carona[]>;
  updateCarona(id: string, data: UpdateCaronaDTO): Promise<Carona>;
  deleteUserCarona(id: string, userId: string): Promise<void>;
  updateCaronaStatus(id: string, status: string): Promise<Carona>;
  getNearCaronas(latitude: number, longitude: number): Promise<Carona[]>;
}

export interface CreateCaronaDTO {
  motoristaId: string;
  origem: string;
  destino: string;
  dataHora: string;
  vagas: number;
  status?: "disponível" | "lotada" | "finalizada";
  origem_lat?: number;
  origem_lon?: number;
}

export interface UpdateCaronaDTO {
  motoristaId?: string;
  origem?: string;
  destino?: string;
  dataHora?: string;
  vagas?: number;
  status?: "disponível" | "lotada" | "finalizada";
  origem_lat?: number;
  origem_lon?: number;
}

export interface CaronaFilter {
  origin?: string;
  destination?: string;
  departureTime?: Date;
}
