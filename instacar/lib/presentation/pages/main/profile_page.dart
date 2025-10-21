import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instacar/core/services/auth_service.dart' as core_auth;
import 'package:instacar/core/services/user_service.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Função para extrair as iniciais do nome
  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return (words[0][0] + words[words.length - 1][0]).toUpperCase();
    }
  }

  // Função para gerar uma cor baseada no nome
  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.deepOrange,
    ];
    
    int hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  void logout(BuildContext context) {
    core_auth.AuthService.logout();
    GoRouter.of(context).go('/login');
  }

  void navigateToEditProfile(BuildContext context) {
    GoRouter.of(context).go('/edit-profile');
  }

   void availablePlans(BuildContext context) {
    GoRouter.of(context).go('/plans');
  }

  void navigateToTerms(BuildContext context) {
    GoRouter.of(context).push('/terms');
  }

  void navigateToContact(BuildContext context) {
    GoRouter.of(context).push('/contact');
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 5;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3182CE),
              Color(0xFF2B6CB0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with profile info
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Perfil",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    FutureBuilder<Map<String, dynamic>>(
                      future: UserService.getCurrentUser(),
                      builder: (context, snapshot) {
                        String initials = "U";
                        Color avatarColor = const Color(0xFF4A5568);
                        
                        if (snapshot.hasData && snapshot.data!['name'] != null) {
                          final name = snapshot.data!['name'] as String;
                          initials = _getInitials(name);
                          avatarColor = _getAvatarColor(name);
                        }
                        
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                avatarColor,
                                avatarColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<Map<String, dynamic>>(
                      future: UserService.getCurrentUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            "Carregando...",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            "Bem-vindo, Usuário",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final userData = snapshot.data!;
                          final userName = userData['name'] ?? 'Usuário';
                          return Text(
                            "Bem-vindo, $userName",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return const Text(
                            "Bem-vindo, Usuário",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Membro desde 2024",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu items container
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          icon: Icons.person,
                          text: "Editar Perfil",
                          subtitle: "Atualize suas informações",
                          onTap: () => navigateToEditProfile(context),
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          icon: Icons.person,
                          text: "Planos",
                          subtitle: "Veja nossos planos disponíveis",
                          onTap: () => availablePlans(context),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          text: "Minhas Solicitações",
                          subtitle: "Veja suas solicitações de carona",
                          onTap: () => navigateToMinhasSolicitacoes(context),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuItem(
                          icon: Icons.description,
                          text: "Termos de serviço",
                          subtitle: "Leia nossos termos",
                          onTap: () => navigateToTerms(context),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuItem(
                          icon: Icons.headphones,
                          text: "Fale conosco",
                          subtitle: "Entre em contato",
                          onTap: () => navigateToContact(context),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuItem(
                          icon: Icons.logout,
                          text: "Logout",
                          subtitle: "Sair da sua conta",
                          isLogout: true,
                          onTap: () => logout(context),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: currentIndex),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    String? subtitle,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isLogout 
                          ? [const Color(0xFFE53E3E), const Color(0xFFC53030)]
                          : [const Color(0xFF3182CE), const Color(0xFF2B6CB0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (isLogout ? const Color(0xFFE53E3E) : const Color(0xFF3182CE)).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon, 
                      size: 24, 
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isLogout ? const Color(0xFFE53E3E) : const Color(0xFF2D3748),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A5568),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isLogout ? const Color(0xFFE53E3E) : const Color(0xFF4A5568),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void navigateToMinhasSolicitacoes(BuildContext context) {
  GoRouter.of(context).go('/minhas-solicitacoes');
}
