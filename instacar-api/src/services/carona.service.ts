import {
  CaronaFilter,
  CreateCaronaDTO,
  ICaronaService,
  UpdateCaronaDTO,
} from "../interfaces/carona-service.interface";
import Carona from "../models/carona";
import { validateCaronaData } from "../utils/carona-validator";
import User from "../models/User";

const CaronaService: ICaronaService = {
  async createCarona(data: CreateCaronaDTO): Promise<Carona> {
    validateCaronaData(data);

    const carona = await Carona.create(data);
    return carona;
  },

  async getCaronaById(id: string): Promise<Carona | null> {
    const carona = await Carona.findByPk(id, {
      include: [
        {
          model: User,
          as: "motorista",
          attributes: ["id", "name", "email", "fotoPerfil", "birthDate", "gender", "tipoVeiculo", "modeloVeiculo", "corVeiculo", "placa"],
        },
      ],
    });
    return carona;
  },

  async listCaronas(filter?: CaronaFilter): Promise<Carona[]> {
    function cleanFilter(filter: CaronaFilter): Partial<CaronaFilter> {
      return Object.fromEntries(
        Object.entries(filter).filter(([_, v]) => v !== undefined)
      ) as Partial<CaronaFilter>;
    }

    const whereFilter = filter ? cleanFilter(filter) : {};

    const caronas = await Carona.findAll({
      where: whereFilter,
      include: [
        {
          model: User,
          as: "motorista",
          attributes: ["id", "name", "email", "fotoPerfil", "birthDate", "gender", "tipoVeiculo", "modeloVeiculo", "corVeiculo", "placa"],
        },
      ],
    });

    return caronas;
  },

  async updateCarona(id: string, data: UpdateCaronaDTO): Promise<Carona> {
    const carona = await Carona.findByPk(id);
    if (!carona) {
      throw new Error("Carona not found");
    }
    await carona.update(data);
    return carona;
  },

  async deleteUserCarona(id: string, userId: string): Promise<void> {
    const carona = await Carona.findOne({ where: { id, motoristaId: userId } });
    if (!carona) {
      throw new Error("Carona not found or you are not the owner");
    }

    await carona.destroy();
  },

  async getAllCaronas() {
    const caronas = await Carona.findAll({
      include: [
        {
          model: User,
          as: "motorista",
          attributes: ["id", "name", "email", "fotoPerfil", "birthDate", "gender", "tipoVeiculo", "modeloVeiculo", "corVeiculo", "placa"],
        },
      ],
    });
    return caronas;
  },

  async updateCaronaStatus(id: string, status: string): Promise<Carona> {
    const carona = await Carona.findByPk(id);
    if (!carona) {
      throw new Error("Carona not found");
    }
    carona.status = status as "disponível" | "lotada" | "finalizada";
    await carona.save();
    return carona;
  },

  async getNearCaronas(
    latitude: number,
    longitude: number,
    radioKm: number = 10
  ): Promise<Carona[]> {
    const earthRadius = 6371;

    const caronas = await Carona.sequelize?.query(
      `
      SELECT * FROM (
          SELECT *, (
              ${earthRadius} * ACOS(
                  COS(RADIANS(:latitude)) * COS(RADIANS(origem_lat)) *
                  COS(RADIANS(origem_lon) - RADIANS(:longitude)) +
                  SIN(RADIANS(:latitude)) * SIN(RADIANS(origem_lat))
              )
          ) AS distance
          FROM "Caronas"
      ) AS subquery
      ORDER BY distance ASC;
      `,
      {
        replacements: { latitude, longitude, radioKm },
        model: Carona,
        mapToModel: true,
      }
    );

    return caronas || [];
  },
};

export default CaronaService;
