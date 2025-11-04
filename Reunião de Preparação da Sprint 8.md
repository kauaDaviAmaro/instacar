# 🗓️ Ata do Planejamento da Sprint — 05/11 a 11/11

**Data:** 29/10/2025  
**Scrum Master:** Leonardo Nakamura  
**Product Owner:** João Gabriel Pieraço  
**Participantes:** João Gabriel, Leonardo Nakamura, Kauã Davi, Lucca Gonçalves, Lucas Simões  
**Duração:** 40 minutos

---

## 🎯 Objetivo da Sprint
> Consolidar o módulo de geolocalização e experiência do usuário no mapa, implementando diferenciação visual de perfis, integração de endpoints e modais informativos para corridas e caronas.  
> O foco é entregar uma interface funcional que una **localização em tempo real**, **dados de caronas** e **distinção de usuários** por meio de ícones e cores.

---

## 🔍 Revisão da Sprint anterior
- ✅ **Entregas concluídas:** Implementação dos markers no mapa, funções de localização e integração visual.  
- ⚠️ **Pendências:** Pop-up interativo por marker ainda requer refinamento e responsividade.  
- 📈 **Lições aprendidas:** Necessidade de maior tempo de testes visuais antes da integração backend → frontend e melhor gestão de tempo em tarefas simultâneas.

---

## 🧩 Capacidade e Planejamento
| Membro | Disponibilidade (h) | Observações |
| :-- | :--: | :-- |
| João Gabriel | 16h | Foco em frontend e integração com modais |
| Leonardo Nakamura | 14h | Suporte geral e code review |
| Kauã Davi | 18h | Foco em endpoints e APIs |
| Lucca Gonçalves | 12h | Responsável por ícones e UI de distinção |
| Lucas Simões | 10h | Suporte em QA e testes |
| **Total estimado:** | **70h** |  |

---

## 🗃️ Itens do Backlog selecionados
| ID / Chave | Descrição | Estimativa | Responsável | Status |
| :- | :- | :-: | :- | :-: |
| SCRUM-108 | Criação de distinção de usuário por meio de ícones e outras funcionalidades | 7 pts | João Gabriel | 🔲 |
| SCRUM-109 | Criação do modal para informações de carona no mapa | 8 pts | Lucca Gonçalves | 🔲 |
| SCRUM-94 | Desenvolver endpoint para receber e salvar a localização compartilhada | 9 pts | Kauã Davi | 🔲 |
| SCRUM-107 | Criação do endpoint das coordenadas dos markers de acordo com os cards | 8 pts | Kauã Davi | 🔲 |
| SCRUM-93 | Criar API para fornecer dados de geolocalização dos veículos | 9 pts | Kauã Davi | 🔲 |

---

## ⚙️ Tarefas e dependências
- O **modal de informações (SCRUM-109)** depende do endpoint de dados de localização (**SCRUM-93**) para exibir as caronas corretamente.  
- A **distinção de usuários (SCRUM-108)** utilizará ícones que também serão integrados ao mapa — precisa do retorno do endpoint (**SCRUM-107**) para renderização dos ícones.  
- O **endpoint de coordenadas (SCRUM-107)** e o **de localização compartilhada (SCRUM-94)** devem ser testados em conjunto para sincronização entre usuário e veículo.

---

## ⚠️ Riscos e mitigações
| Risco | Impacto | Mitigação |
| :-- | :-- | :-- |
| Atraso na integração de endpoints | Médio | Priorizar endpoints na primeira metade da sprint e realizar testes unitários antes do merge |
| Diferenças visuais entre ícones em dispositivos Android/iOS | Baixo | Padronizar SVGs e realizar testes de compatibilidade com Flutter |
| Problemas de sincronização entre mapa e backend | Alto | Implementar logs de requisição e monitorar respostas em tempo real |

---

## 🧭 Conclusão
- **Sprint Goal confirmado:** ✅ Sim  
- **Backlog comprometido:** ✅  
- **Próxima daily:** 30/10/2025 às 09h00  
- **Anotações finais:**  
  O foco será a **finalização da integração de geolocalização** e **refinamento da interface**. Essa sprint consolida o último bloco técnico do sistema antes da entrega do MVP do InstaCar.

---

✅ **Checklist de encerramento**
- [x] Sprint Goal definido e registrado  
- [x] Itens da sprint movidos para a nova Sprint no Jira Board  
- [x] Pendências da sprint anterior replanejadas  
- [x] A ata foi atualizada e compartilhada com o time  
