# Reunião de Preparação (Planning) do Sprint

**Tema**: Planejamento do Sprint 7

**Objetivo Principal:** Definir o Escopo de Trabalho, estabelecer a Meta do Sprint e garantir que os itens estejam prontos para o desenvolvimento.

<br>

## 1. Revisão da Capacidade

**Velocidade Histórica: (pontos de 0 a 10)**

- **10 pontos:** Caso siga o desenvolvimento da última sprint 6, a equipe está desenvolvendo o sistema com uma média considerável, as tasks do JIRA estão sendo executadas no tempo determinado pelo scrum master, sendo todas finalizadas.  

**Fatores de Limitação: (pontos de 0 a 10)**

- **7 pontos:** Ainda há algumas dificuldades com comunicação entre integrantes do grupo, pois ocorre muitas faltas por parte de alguns, foi melhorado um pouco por parte dos demais, mas ainda acarreta em desalinhamento de ideias e consequentemente a task fica atrasada, como mencionada no tópico acima.

**Capacidade Estimada para o Sprint: (pontos de 0 a 10)**
- **9 pontos:** Entregaremos todas as tasks propostas no prazo proposto, isso vem devido esforço do time e cobrança do scrum master.

<br>

    
**Inicio 22/10/2025 - Final 28/10/2025**

<br>

## 2. Definição e Acordo da Meta

**Meta da Sprint:**
- **Adicionar markers no mapa com base nas coordenadas:** Implementar markers dinâmicos no mapa de acordo com as coordenadas fornecidas pelos cards, garantindo que a visualização seja responsiva e clara para o usuário final.;

- **Criar pop-up interativo por marker:** Desenvolver pop-ups informativos e responsivos vinculados a cada marker, exibindo informações detalhadas do veículo ao clicar ou passar o cursor.

- **Implementar API de geolocalização:** Criar uma API para fornecer dados atualizados de localização dos veículos, permitindo a integração em tempo real com o front-end.

- **Desenvolver endpoint de recebimento de localização:** Construir um endpoint para receber e armazenar as localizações compartilhadas pelos dispositivos ou sistemas integrados.

- **Representar visualmente os veículos no mapa:** Garantir que todos os dados recebidos sejam representados graficamente em um mapa interativo, proporcionando ao usuário uma visão geral e precisa das posições em tempo real.

<br>


## 3. Seleção e Estimativa do Escopo

- **Tipo:** Tarefa; **Título do Item:** Criação de markers de acordo com coordenada de cards; **Estimativa:** 9 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Criação de pop-up por markers; **Estimativa:** 6 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Criar API para fornecer dados de geolocalização dos veículos; **Estimativa:** 9 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Desenvolver endpoint para recebeer e salvar localização compartilhada; **Estimativa:** 8 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Rpresentação visual dos veículos em um mapa; **Estimativa:** 9 Pontos;


<br>

## 4. Decisões e Dependências

**a) Decisões Chave**

- Uso de ferramentas simples para criação dos markers para representação dos veículos em sua posição de latitude ou endereço em relação ao mapa de acordo com as coordenadas passadas pelor oferecedores de carona.

- Uso de ferramentas visuais, icones ou logos para distinção de usuários que estão disponibilizando corridas ou estão em movimento se possível;

- Uso da API do google ou do leaflet, tudo a depender da capacidade e da compatibilidade de nós desenvolvedores utilizarmos uma das APIs. Iremos utilizar e testar qual delas é melhor, e mais compatível com nosso aplicativo.

<br>


**b) Dependências ou Riscos:**

- **Atualização em tempo real dos markers:** A implementação de atualização automática e em tempo real dos markers depende de sincronização constante com os dispositivos dos usuários. Isso pode exigir integração mais avançada, o que pode impactar prazos. Caso haja tempo até 04/11/2025, será tentado implementar.

- **Compatibilidade e performance do mapa:** A escolha entre as bibliotecas (Google Maps ou Leaflet) dependerá de testes de compatibilidade e desempenho no ambiente mobile. Existe risco de ajustes extras caso a solução inicial apresente limitações técnicas ou de custo.

- **Precisão e estabilidade da API de geolocalização:** Como a solução depende de dados externos fornecidos pelos usuários, variações de precisão e latência podem afetar a experiência de uso. Caso seja necessário, ajustes poderão ser feitos até 04/11/2025.

- **Compartilhamento de localização ativa:** A funcionalidade de compartilhamento contínuo envolve maior complexidade técnica, principalmente em relação a notificações e status em tempo real. Caso não seja viável no escopo principal, poderá ser considerada uma implementação adicional até 04/11/2025.

- **Dependência de infraestrutura externa:** O funcionamento depende de conectividade estável e das APIs de mapas. Instabilidades externas podem impactar a entrega final ou exigir adaptações temporárias.