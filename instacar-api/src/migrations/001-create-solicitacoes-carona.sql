-- Migration para criar a tabela de solicitações de carona
-- Execute este script no seu banco de dados PostgreSQL

CREATE TABLE IF NOT EXISTS "SolicitacoesCarona" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "caronaId" UUID NOT NULL,
    "passageiroId" UUID NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'pendente' CHECK (status IN ('pendente', 'aceita', 'rejeitada', 'cancelada')),
    "mensagem" TEXT,
    "dataSolicitacao" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Foreign keys
    CONSTRAINT "FK_SolicitacaoCarona_Carona" 
        FOREIGN KEY ("caronaId") REFERENCES "Caronas"("id") ON DELETE CASCADE,
    CONSTRAINT "FK_SolicitacaoCarona_Passageiro" 
        FOREIGN KEY ("passageiroId") REFERENCES "Users"("id") ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT "CHK_SolicitacaoCarona_Status" 
        CHECK (status IN ('pendente', 'aceita', 'rejeitada', 'cancelada')),
    CONSTRAINT "CHK_SolicitacaoCarona_Mensagem" 
        CHECK (LENGTH(mensagem) <= 500)
);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS "IDX_SolicitacoesCarona_CaronaId" ON "SolicitacoesCarona"("caronaId");
CREATE INDEX IF NOT EXISTS "IDX_SolicitacoesCarona_PassageiroId" ON "SolicitacoesCarona"("passageiroId");
CREATE INDEX IF NOT EXISTS "IDX_SolicitacoesCarona_Status" ON "SolicitacoesCarona"("status");
CREATE INDEX IF NOT EXISTS "IDX_SolicitacoesCarona_DataSolicitacao" ON "SolicitacoesCarona"("dataSolicitacao");

-- Índice composto para consultas frequentes
CREATE INDEX IF NOT EXISTS "IDX_SolicitacoesCarona_CaronaId_Status" ON "SolicitacoesCarona"("caronaId", "status");
CREATE INDEX IF NOT EXISTS "IDX_SolicitacoesCarona_PassageiroId_Status" ON "SolicitacoesCarona"("passageiroId", "status");

-- Comentários para documentação
COMMENT ON TABLE "SolicitacoesCarona" IS 'Tabela para armazenar solicitações de carona entre usuários';
COMMENT ON COLUMN "SolicitacoesCarona"."id" IS 'Identificador único da solicitação';
COMMENT ON COLUMN "SolicitacoesCarona"."caronaId" IS 'ID da carona solicitada';
COMMENT ON COLUMN "SolicitacoesCarona"."passageiroId" IS 'ID do usuário que solicitou a carona';
COMMENT ON COLUMN "SolicitacoesCarona"."status" IS 'Status da solicitação: pendente, aceita, rejeitada, cancelada';
COMMENT ON COLUMN "SolicitacoesCarona"."mensagem" IS 'Mensagem opcional do passageiro para o motorista';
COMMENT ON COLUMN "SolicitacoesCarona"."dataSolicitacao" IS 'Data e hora em que a solicitação foi feita';
