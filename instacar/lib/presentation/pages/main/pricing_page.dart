import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Tenta voltar no histórico, se não conseguir vai para login
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
        title: const Text(
          'Planos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Escolha o melhor plano para se locomover:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Plano Básico
            _buildPlanCard(
              context: context,
              title: 'Básico',
              price: '00',
              description: 'Para os iniciantes que querem conhecer melhor nosso aplicativo, vá para aonde quiser regulando seus gastos e economizando:',
              features: const [
                'Sem custos',
                'Uso de nossas ferramentas',
                'Uso de nossas ferramentas',
                'Ferramentas premium bloqueadas',
              ],
              isPopular: false,
              onTap: () {
                // Navegar para o cadastro com plano básico
                context.go('/register?plan=basic');
              },
            ),
            
            const SizedBox(height: 30),
            
            // Plano Premium
            _buildPlanCard(
              context: context,
              title: 'Premium',
              price: '20',
              description: 'O Plano Premium é o plano mais indicado para melhor uso dos nossos usuários, aproveitamento de todas nossas ferramentas e funcionalidades avançadas:',
              features: const [
                'Liberação todas as ferramentas e uso disponíveis no modo grátis',
                'Uso de todas as ferramentas disponíveis',
                'Sem Anúncios',
                'Filtros mais complexos liberados',
                'Maior número salvos em favoritos',
              ],
              isPopular: true,
              onTap: () {
                // Navegar para o cadastro com plano premium
                context.go('/register?plan=premium');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required bool isPopular,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Most Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isPopular ? 40 : 20),
                
                // Preço
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        '/por mês',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Título
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Descrição
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Lista de features
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        feature == 'Ferramentas premium bloqueadas' 
                            ? Icons.cancel 
                            : Icons.bookmark,
                        color: feature == 'Ferramentas premium bloqueadas' 
                            ? Colors.red 
                            : const Color(0xFF4A90E2),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 14,
                            color: feature == 'Ferramentas premium bloqueadas' 
                                ? Colors.red 
                                : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 32),
                
                // Botão
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Escolha Plano',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
