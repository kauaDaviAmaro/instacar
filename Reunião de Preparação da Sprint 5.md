# Reunião de Preparação (Planning) do Sprint

**Tema**: Planejamento do Sprint 5

**Objetivo Principal:** Definir o Escopo de Trabalho, estabelecer a Meta do Sprint e garantir que os itens estejam prontos para o desenvolvimento.

<br>

## 1. Revisão da Capacidade

**Velocidade Histórica: (pontos de 0 a 10)**

- **9 pontos:** No geral, a equipe está desenvolvendo o sistema com uma média considerável, estamos completando tasks do JIRA no tempo determinado pelo scrum, dificilmente alguma task é deixada para trás por conta do tempo.  

**Fatores de Limitação: (pontos de 0 a 10)**

- **8 pontos:** Há algumas dificuldades com comunicação entre integrantes do grupo, pois ocorre muitas faltas por parte de alguns, com isso, acarreta em desalinhamento de ideias e consequentemente a task fica atrasada, como mencionada no tópico acima.

**Capacidade Estimada para o Sprint: (pontos de 0 a 10)**
- **9 pontos:** Entregaremos todas as tasks propostas pelo scrum dentro do prazo estimado.

    
**Inicio 12/10/2025 - Final 21/10/2025**

<br>

## 2. Definição e Acordo da Meta

- **Diferenciar perfil premium do perfil gratuito:** Adicionar a coluna do plano premium no banco de dados, para fazermos a distinção de display do usuário simples e premium por meio de avatares diferentes, e por meio de benefícios diferentes.

- **Adicionar cards de novos planos:** Adicionar frontend e backend dos tipos de planos de usuários grátis e premium, sendo a criação dos cards, conexão com tipo de perfil e responsvidade perante alteração.

- **Adicionar banco de dados de novos planos:** Criação nova coluna no banco de dados de tipo de usuário, para que haja distinção de tipo usuário e alteração no tipo do avatar.

<br>


## 3. Seleção e Estimativa do Escopo

- **Tipo:** Tarefa; **Título do Item:** Criação tipos de perfil e avatar por tipo de plano; **Estimativa:** 6 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Adicionar atualização para o plano premium; **Estimativa:** 6 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Criação de pop-up responsivo seguido de finalização de corrida; **Estimativa:** 7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Avaliação de caronas/usuários; **Estimativa:** 7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Adicionar tabelas de avaliação de caronas/usuários; **Estimativa:** 7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Atualização status em banco de dados para o plano premium; **Estimativa:** 8 Pontos;

<br>

## 4. Decisões e Dependências

**a) Decisões Chave**

- Uso de ferramentas visuais, icones ou logos para distinção de usuários básicos e premiuns;

- Uso de ferramentas simples para criação do pop-up de avaliação de corrida, somente será requisitado a todos e sempre a obrigatoriedade de avaliação visto a necessidade de aumentar nosso banco de dados e informações sobre o perfis dos motoristas.

- Uso da API do google ou do leaflet, tudo a depender da capacidade e da compatibilidade de nós desenvolvedores utilizarmos uma das APIs. Iremos utilizar e testar qual delas é melhor, e mais compatível com nosso aplicativo.

**b) Dependências ou Riscos:**

- **Adicionar atualização para o plano premium:** .Primordial para continuidade da atividade da "Criação tipos de perfil e avatar por tipo de plano", por isso foi feito primeiro;

- **Criação tipos de perfil e avatar por tipo de plano:** Uso de efeitos visuais no avatar para distinção de perfis e aumento de benefícios. Para inicio teve de aguardar a atvidade acima;

- **Atualização status em banco de dados para o plano premium:** Adicionamento da coluna no banco de dados. Feito será liberado para o display dos tipos de usuários, avatares e beneficios;

- **Avaliação de caronas/usuários:** Criação das regras de negócio e como será disponibilizado para avaliação constante e quando desejada do perfil dos usuários. Primodial para dar continuidade em criação da "tabelas de avaliação de caronas/usuários", "Atualização status em banco de dados para o plano premium" e  "Criação de pop-up responsivo seguido de finalização de corrida";

- **Adicionar tabelas de avaliação de caronas/usuários:** Algo mais complexo devido toda regra de relacionamento dos usuários, quem poderá adicionar o comentário com relação assim ao ID e como iremos disponibiliza-los. Importante para "Criação de pop-up responsivo seguido de finalização de corrida" devido ser necessário ;

-- **Criação de pop-up responsivo seguido de finalização de corrida:** Criação do pop-up responsivo de forma simples, uso de um modelo similar do bootstrap, mas utilizando do fluttergems como no caso da criação de corridas. Uso desse framework por outro integrante do grupo dificuldade como o João Gabriel teve;
