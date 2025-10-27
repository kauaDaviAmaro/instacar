import { Request, Response } from "express";
import SolicitacaoCarona from "../models/solicitacao-carona";
import Carona from "../models/carona";
import Usuario from "../models/User";
import { IAuthRequest } from "../types";

import { MESSAGES } from "../utils/messages";

const solicitacaoCaronaController = {
  // Usuário solicita uma carona
  solicitarCarona: async (req: IAuthRequest, res: Response): Promise<void> => {
    try {
      const { caronaId, mensagem } = req.body;
      const passageiroId = req.user?.userId;

      if (!passageiroId) {
        res.status(401).json({ message: MESSAGES.USER.INVALID_USER });
        return;
      }

      // Verificar se a carona existe e tem vagas
      const carona = await Carona.findByPk(caronaId, {
        include: [
          {
            model: Usuario,
            as: "motorista"
          }
        ]
      });

      if (!carona) {
        res.status(404).json({ message: "Carona não encontrada" });
        return;
      }

      if (carona.motoristaId === passageiroId) {
        res.status(400).json({ message: "Você não pode solicitar sua própria carona" });
        return;
      }

      if (carona.status !== "disponível") {
        res.status(400).json({ message: "Esta carona não está mais disponível" });
        return;
      }

      // Verificar se já existe uma solicitação pendente
      const solicitacaoExistente = await SolicitacaoCarona.findOne({
        where: {
          caronaId,
          passageiroId,
          status: "pendente"
        }
      });

      if (solicitacaoExistente) {
        res.status(400).json({ message: "Você já solicitou esta carona" });
        return;
      }

      const novaSolicitacao = await SolicitacaoCarona.create({
        caronaId,
        passageiroId,
        mensagem,
        status: "pendente",
      });

      // Buscar a solicitação com os dados relacionados
      const solicitacaoCompleta = await SolicitacaoCarona.findByPk(novaSolicitacao.id, {
        include: [
          {
            model: Carona,
            as: "carona",
            include: [
              {
                model: Usuario,
                as: "motorista"
              }
            ]
          },
          {
            model: Usuario,
            as: "passageiro"
          }
        ]
      });

      res.status(201).json(solicitacaoCompleta);
    } catch (error) {
      console.error('Erro ao solicitar carona:', error);
      res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR });
    }
  },

  // Motorista vê suas solicitações recebidas
  getSolicitacoesRecebidas: async (req: IAuthRequest, res: Response): Promise<void> => {
    try {
      const motoristaId = req.user?.userId;
      
      if (!motoristaId) {
        res.status(401).json({ message: MESSAGES.USER.INVALID_USER });
        return;
      }

      const solicitacoes = await SolicitacaoCarona.findAll({
        where: {
          status: "pendente"
        },
        include: [
          {
            model: Carona,
            as: "carona",
            where: { motoristaId },
            include: [
              {
                model: Usuario,
                as: "motorista"
              }
            ]
          },
          {
            model: Usuario,
            as: "passageiro"
          }
        ],
        order: [['dataSolicitacao', 'DESC']]
      });

      res.json(solicitacoes);
    } catch (error) {
      console.error('Erro ao buscar solicitações:', error);
      res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR });
    }
  },

  // Motorista aceita/rejeita solicitação
  responderSolicitacao: async (req: IAuthRequest, res: Response): Promise<void> => {
    try {
      const { solicitacaoId } = req.params;
      const { status } = req.body; // "aceita" ou "rejeitada"
      const motoristaId = req.user?.userId;

      if (!motoristaId) {
        res.status(401).json({ message: MESSAGES.USER.INVALID_USER });
        return;
      }

      if (!["aceita", "rejeitada"].includes(status)) {
        res.status(400).json({ message: "Status inválido. Use 'aceita' ou 'rejeitada'" });
        return;
      }

      const solicitacao = await SolicitacaoCarona.findByPk(solicitacaoId, {
        include: [
          {
            model: Carona,
            as: "carona"
          }
        ]
      });

      if (!solicitacao) {
        res.status(404).json({ message: "Solicitação não encontrada" });
        return;
      }

      // Acessar a carona através do relacionamento
      const carona = (solicitacao as any).carona;
      if (!carona) {
        res.status(404).json({ message: "Carona não encontrada" });
        return;
      }

      if (carona.motoristaId !== motoristaId) {
        res.status(403).json({ message: "Você não tem permissão para responder esta solicitação" });
        return;
      }

      if (solicitacao.status !== "pendente") {
        res.status(400).json({ message: "Esta solicitação já foi respondida" });
        return;
      }

      await solicitacao.update({ status });

      // Se aceita, decrementar vagas disponíveis
      if (status === "aceita") {
        const vagasDisponiveis = carona.vagasDisponiveis || carona.vagas;
        if (vagasDisponiveis <= 0) {
          res.status(400).json({ message: "Não há mais vagas disponíveis nesta carona" });
          return;
        }

        await Carona.update(
          { vagasDisponiveis: vagasDisponiveis - 1 },
          { where: { id: solicitacao.caronaId } }
        );

        // Verificar se a carona ficou lotada
        const caronaAtualizada = await Carona.findByPk(solicitacao.caronaId);
        if (caronaAtualizada && (caronaAtualizada.vagasDisponiveis ?? 0) <= 0) {
          await Carona.update(
            { status: "lotada" },
            { where: { id: solicitacao.caronaId } }
          );
        }
      }

      // Buscar a solicitação atualizada com os dados relacionados
      const solicitacaoAtualizada = await SolicitacaoCarona.findByPk(solicitacaoId, {
        include: [
          {
            model: Carona,
            as: "carona",
            include: [
              {
                model: Usuario,
                as: "motorista"
              }
            ]
          },
          {
            model: Usuario,
            as: "passageiro"
          }
        ]
      });

      res.json(solicitacaoAtualizada);
    } catch (error) {
      console.error('Erro ao responder solicitação:', error);
      res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR });
    }
  },

  // Usuário vê suas solicitações enviadas
  getMinhasSolicitacoes: async (req: IAuthRequest, res: Response): Promise<void> => {
    try {
      const passageiroId = req.user?.userId;
      
      if (!passageiroId) {
        res.status(401).json({ message: MESSAGES.USER.INVALID_USER });
        return;
      }
      
      const solicitacoes = await SolicitacaoCarona.findAll({
        where: { passageiroId },
        include: [
          {
            model: Carona,
            as: "carona",
            include: [
              {
                model: Usuario,
                as: "motorista"
              }
            ]
          }
        ],
        order: [['dataSolicitacao', 'DESC']]
      });

      res.json(solicitacoes);
    } catch (error) {
      console.error('Erro ao buscar minhas solicitações:', error);
      res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR });
    }
  },

  // Cancelar solicitação (apenas se ainda estiver pendente)
  cancelarSolicitacao: async (req: IAuthRequest, res: Response): Promise<void> => {
    try {
      const { solicitacaoId } = req.params;
      const passageiroId = req.user?.userId;

      if (!passageiroId) {
        res.status(401).json({ message: MESSAGES.USER.INVALID_USER });
        return;
      }

      const solicitacao = await SolicitacaoCarona.findByPk(solicitacaoId);

      if (!solicitacao) {
        res.status(404).json({ message: "Solicitação não encontrada" });
        return;
      }

      if (solicitacao.passageiroId !== passageiroId) {
        res.status(403).json({ message: "Você não tem permissão para cancelar esta solicitação" });
        return;
      }

      if (solicitacao.status !== "pendente") {
        res.status(400).json({ message: "Esta solicitação não pode ser cancelada" });
        return;
      }

      await solicitacao.update({ status: "cancelada" });

      res.json({ message: "Solicitação cancelada com sucesso" });
    } catch (error) {
      console.error('Erro ao cancelar solicitação:', error);
      res.status(500).json({ message: MESSAGES.GENERAL.SERVER_ERROR });
    }
  }
};

export default solicitacaoCaronaController;
