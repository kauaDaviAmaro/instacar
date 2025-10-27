# Reunião de Preparação (Planning) do Sprint

**Tema**: Planejamento do Sprint 5 - Frontend e Backend

**Objetivo Principal:** Definir o Escopo de Trabalho, estabelecer a Meta do Sprint e garantir que os itens estejam prontos para o desenvolvimento.

<br>

## 1. Revisão da Capacidade

**Velocidade Histórica: (pontos de 0 a 10)**

- **9 pontos:** No geral, a equipe está desenvolvendo o sistema com uma média considerável, estamos completando tasks do JIRA no tempo determinado pelo scrum, dificilmente alguma task é deixada para trás por conta do tempo.  

**Fatores de Limitação: (pontos de 0 a 10)**

- **8 pontos:** Há algumas dificuldades com comunicação entre integrantes do grupo, pois ocorre muitas faltas por parte de alguns, com isso, acarreta em desalinhamento de ideias e consequentemente a task fica atrasada, como mencionada no tópico acima.

**Capacidade Estimada para o Sprint: (pontos de 0 a 10)**
- **9 pontos:** Entregaremos todas as tasks propostas pelo scrum dentro do prazo estimado.

    
**Inicio 12/10/2025 - Final 30/10/2025**

<br>

## 2. Definição e Acordo da Meta

**Meta da Sprint:**
- **Adicionar mapa na tela principal:** Adicionar na homepage o botão para transicionar do display de cards para mapa e vice-versa. Sendo algo responsivo e uma transição simples user friendly.;

- **Diferenciar perfil premium do perfil gratuito:** Adicionar a coluna do plano premium no banco de dados, para fazermos a distinção de display do usuário simples e premium por meio de avatares diferentes, e por meio de benefícios diferentes.

- **Criar Pop-up responsivo de avaliação:** Criação de um pop-up responsivo que aparece após a finalização de uma prestação de carona, sendo a avaliação obrigatória e caso não realizado não será possível fechar o pop-up.

<br>


## 3. Seleção e Estimativa do Escopo

- **Tipo:** Tarefa; **Título do Item:** Criação tipos de perfil e avatar por tipo de plano; **Estimativa:** 6 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Criação de pop-up responsivo seguido de finalização de corrida; **Estimativa:** 7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Adicionar atualização para o plano premium; **Estimativa:**6 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Adicionar avaliação de caronas/usuários; **Estimativa:**7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Criação de botão para display de mapa na landing page; **Estimativa:** 9 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Avaliação de caronas/usuários; **Estimativa:** 7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Adicionar tabelas de avaliação de caronas/usuários; **Estimativa:** 7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Atualização status em banco de dados para o plano premium; **Estimativa:** 8 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Endpoint de avaliação; **Estimativa:** 7 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Endpoint de inicio/finalizar corrida; **Estimativa:** 9 Pontos;

- **Tipo:** Tarefa; **Título do Item:** Endpoint de plano premium; **Estimativa:** 7 Pontos;

- **Tipo:** HU; **Título do Item:** Acesso por biometria; **Estimativa:** 7 Pontos;

- **Tipo:** HU; **Título do Item:** Criação markers no mapa responsivos; **Estimativa:** 7 Pontos;

- **Tipo:** HU; **Título do Item:** Criação de compartilhamento de localização em tempo real; **Estimativa:** 7 Pontos;


<br>

## 4. Decisões e Dependências

**a) Decisões Chave**

- Uso de ferramentas visuais, icones ou logos para distinção de usuários básicos e premiuns;

- Uso de ferramentas simples para criação do pop-up de avaliação de corrida, somente será requisitado a todos e sempre a obrigatoriedade de avaliação visto a necessidade de aumentar nosso banco de dados e informações sobre o perfis dos motoristas.

- Uso da API do google ou do leaflet, tudo a depender da capacidade e da compatibilidade de nós desenvolvedores utilizarmos uma das APIs. Iremos utilizar e testar qual delas é melhor, e mais compatível com nosso aplicativo.

**b) Dependências ou Riscos:**

- **Biometria:** não será possível implementar no projeto atualmente e ainda foi retirado perante inutilidade no projeto visto que será mobile, mas irá rodar local. No entanto, caso haja tempo até dia 08/11/2025 será tentado implementar;

- **Mapa com imagem ativa:** Algo um pouco mais complexo devido a necessidade de constante atulização e sincronização com os usuários, visto que somente desse modo podemos mover os markers. Mas, após debate verificou que implementação não seria primordial, visto que a os usuários irão compartilhar sua localização por meio de endereço. No entanto, caso haja tempo até dia 08/11/2025 será tentado implementar;

- **Compartilhamento de localização atual:** Algo mais complexo pelo mesmos motivos do tema acima, visto a dificuldade de cosntante sincronização com os usuários. No entato, pertinente para o projeto para maior segurança de ambas as partes para cosntante notificação de movimentação, localização e status dos usuários no momento que desejarem compartilhar. No entanto, pela ausência de tempo para uma feature complexa nesse calibre, caso haja tempo até dia 08/11/2025 será tentado implementar;