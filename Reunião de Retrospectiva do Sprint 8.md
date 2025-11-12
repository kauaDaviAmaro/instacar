# 🧩 Ata da Retrospectiva da Sprint — Semana 05/10 a 11/11

**Data:** 05/11/2025  
**Facilitador:** Leonardo Nakamura  
**Participantes:** João Gabriel, Leonardo Nakamura, Kauã Davi, Lucca Gonçalves, Lucas Simões  
**Duração:** 40 minutos 
**Sprint analisada:** Sprint 8  

---

## 🔹 Contexto da Sprint

**Objetivo da sprint:**  
Consolidar o módulo de geolocalização, diferenciando usuários por ícones e aprimorando a experiência de uso no mapa com modais informativos e endpoints de sincronização de dados em tempo real.  

**Resultados principais:**  

✅ **Entregas concluídas:**  
- Criação de distinção de usuários por ícones e novas funcionalidades (SCRUM-108)  
- Criação do modal para informações de carona no mapa (SCRUM-109)  
- Desenvolvimento do endpoint para receber e salvar localização compartilhada (SCRUM-94)  
- Criação do endpoint das coordenadas dos markers de acordo com os cards (SCRUM-107)  
- Criação da API para fornecer dados de geolocalização dos veículos (SCRUM-93)  

⚠️ **Pendências / problemas:**  
- Ajuste fino da atualização automática de localização em tempo real (refresh interval e cache).  
- Modal de informações ainda necessita otimização para diferentes tamanhos de tela.  

📊 **Métrica:**  
- Velocidade da equipe: **10/10**  
- Tarefas planejadas: **5**  
- Tarefas concluídas: **5 (100%)**  

---

## 💬 Reflexão do Time

### 🚀 O que foi bem?
- Todas as entregas foram finalizadas dentro do prazo, com integração funcional entre frontend e backend.  
- A comunicação entre os membros foi eficiente e as dailys ocorreram regularmente.  
- O mapa agora exibe dados precisos de localização e distingue visualmente os usuários, agregando valor ao MVP.  

### ⚠️ O que pode melhorar?
- Falta de padronização nas respostas das APIs (nomes de campos e tipos de dados divergentes).  
- Testes de interface em dispositivos menores foram deixados para o final, o que atrasou ajustes visuais.  

### 💡 Ideias / sugestões
- Criar um **guia de padronização de endpoints e respostas JSON**.  
- Incluir testes automatizados de layout com Flutter Test para evitar regressões visuais.  

---

## 🧭 Ações de Melhoria (para próxima sprint)

| Nº | Ação / Iniciativa | Responsável | Prazo | Status |
|----|-------------------|--------------|--------|--------|
| 1 | Padronizar as respostas das APIs de geolocalização e markers | Kauã Davi | 11/11/2025 | 🔲 A fazer |
| 2 | Otimizar o modal informativo para telas menores | Lucca Gonçalves | 11/11/2025 | 🔲 A fazer |
| 3 | Criar documentação de integração entre frontend e backend | Leonardo Nakamura | 11/11/2025 | 🔲 A fazer |

---

## 🗒️ Feedback rápido

**Sentimento geral da equipe:** 😀  
**Comentários adicionais:**  
A Sprint 8 marcou a consolidação do sistema de geolocalização e o amadurecimento técnico do time. O projeto está em nível de MVP funcional, com entregas consistentes e colaboração fluida. O foco agora será na estabilidade, testes e documentação antes da apresentação final.
