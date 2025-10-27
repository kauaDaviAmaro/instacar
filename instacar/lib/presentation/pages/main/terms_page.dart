import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermosDeServicoPage extends StatelessWidget {
  const TermosDeServicoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        title: const Text('Termos de serviço'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Última atualização 28/05/2025',
              style: TextStyle(fontSize: 12, color: Colors.black38),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const Text('''
  Termos e Condições de Uso
Este Termo e Condições de Uso regulamenta o uso do aplicativo de caronas compartilhadas (“Aplicativo”) desenvolvido pela nossa startup, destinado à conexão de motoristas e passageiros interessados em compartilhar trajetos urbanos e interurbanos. Ao utilizar o Aplicativo, o usuário concorda com todas as condições aqui descritas.
  1. Sobre o Aplicativo
O Aplicativo tem como objetivo principal facilitar o compartilhamento de caronas entre usuários, com foco em sustentabilidade, economia e segurança. Ele oferece funcionalidades como: cadastro de usuários e veículos, busca por rotas otimizadas, integração com sistemas de pagamento, e um sistema de reputação baseado em avaliações entre passageiros e motoristas.
  2. Cadastro e Responsabilidades do Usuário
O usuário deve fornecer informações verdadeiras e completas no momento do cadastro. É responsabilidade do usuário manter suas informações atualizadas, respeitar os demais usuários, cumprir horários acordados e manter a cordialidade durante as viagens. Usuários que apresentarem comportamentos inadequados poderão ser suspensos ou excluídos da plataforma.
  3. Conduta e Convivência
Todos os usuários devem agir com respeito, ética e civilidade. É estritamente proibido o uso do Aplicativo para fins ilícitos, assédio, discriminação, transporte de substâncias ilegais ou de pessoas contra sua vontade. A startup reserva-se o direito de bloquear o acesso ao Aplicativo em casos de má conduta.
  4. Segurança e Avaliações
O Aplicativo oferece recursos para que os usuários avaliem suas experiências após cada viagem. Isso contribui para a segurança e qualidade da plataforma. A startup realiza validações básicas, mas não se responsabiliza diretamente por comportamentos individuais. Recomendamos que usuários verifiquem as avaliações e utilizem o chat interno para alinhar expectativas antes do trajeto.
  5. Meios de Pagamento
As transações financeiras são realizadas através do Mercado Pago, plataforma parceira da startup. A utilização deste meio permite segurança nas transações e acesso a benefícios exclusivos para usuários da carteira Mercado Pago. A startup não armazena dados bancários dos usuários e não se responsabiliza por fraudes oriundas de má conduta fora da plataforma.
  6. Alterações e Cancelamentos
Cancelamentos devem ser realizados com no mínimo 1 hora de antecedência da viagem marcada. Em casos de reincidência ou ausência sem justificativa, o usuário poderá receber advertências ou ser suspenso da plataforma.
  7. Propriedade Intelectual
Todos os direitos relacionados ao Aplicativo, incluindo layout, logotipos, algoritmos e funcionalidades, são de propriedade exclusiva da startup, sendo proibida sua reprodução total ou parcial sem autorização prévia.
  8. Disposições Finais
A startup poderá alterar este Termo a qualquer momento, sendo responsabilidade do usuário manter-se atualizado com a versão vigente. O uso contínuo do Aplicativo após alterações será considerado como aceite tácito. Em caso de dúvidas, o contato deve ser feito via canal oficial de suporte dentro do aplicativo.

''', style: TextStyle(fontSize: 14, height: 1.6)),
      ),
    );
  }
}
