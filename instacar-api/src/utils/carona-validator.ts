import { CreateCaronaDTO } from "../interfaces/carona-service.interface";
import { MESSAGES } from "../utils/messages";

export function validateCaronaData(data: CreateCaronaDTO): void {
  if (
    !data.motoristaId ||
    !data.origem ||
    !data.destino ||
    !data.dataHora ||
    data.origem_lat === undefined ||
    data.origem_lon === undefined ||
    data.vagas === undefined
  ) {
    throw new Error(MESSAGES.CARONA.MISSING_FIELDS);
  }

  if (data.vagas < 2) {
    throw new Error(MESSAGES.CARONA.VAGAS_INVALID);
  }

  if (
    data.status &&
    !["disponível", "lotada", "finalizada"].includes(data.status)
  ) {
    throw new Error(MESSAGES.CARONA.STATUS_INVALID);
  }
}
