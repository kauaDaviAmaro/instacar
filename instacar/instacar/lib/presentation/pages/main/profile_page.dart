import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instacar/core/services/auth_service.dart' as core_auth;
import 'package:instacar/core/services/user_service.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';
import 'package:instacar/presentation/widgets/floating_map_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  ScrollController? _scrollController;
  AnimationController? _animationController;
  Animation<double>? _headerAnimation;
  double _scrollOffset = 0.0;
  static const double _maxScrollOffset = 100.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    _scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _scrollController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController != null && _animationController != null) {
      setState(() {
        _scrollOffset = _scrollController!.offset;
      });
      
      final progress = (_scrollOffset / _maxScrollOffset).clamp(0.0, 1.0);
      _animationController!.value = progress;
    }
  }

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
    GoRouter.of(context).go('/pricing');
  }

  void navigateToTerms(BuildContext context) {
    GoRouter.of(context).push('/terms');
  }

  void navigateToContact(BuildContext context) {
    GoRouter.of(context).push('/contact');
  }

  Future<String?> _loadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_plan');
  }

  Widget _buildAnimatedAvatar() {
    return AnimatedBuilder(
      animation: _headerAnimation ?? const AlwaysStoppedAnimation(1.0),
      builder: (context, child) {
        final scale = _headerAnimation?.value ?? 1.0;
        final isMinimized = scale < 0.4;
        
        return FutureBuilder<Map<String, dynamic>>(
          future: UserService.getCurrentUser(),
          builder: (context, snapshot) {
            String initials = "U";
            Color avatarColor = const Color(0xFF4A5568);
            
            if (snapshot.hasData && snapshot.data!['name'] != null) {
              final name = snapshot.data!['name'] as String;
              initials = _getInitials(name);
              avatarColor = _getAvatarColor(name);
            }
            
            // Tamanhos diferentes para estados minimizado e expandido
            final avatarSize = isMinimized ? 40.0 : 120.0;
            final fontSize = isMinimized ? 16.0 : 48.0;
            
            final avatar = Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    avatarColor,
                    avatarColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(avatarSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );

            return FutureBuilder<String?>(
              future: _loadPlan(),
              builder: (context, planSnap) {
                final isPremium = planSnap.data == 'premium';
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    avatar,
                    if (isPremium)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: isMinimized ? 18 : 28,
                          height: isMinimized ? 18 : 28,
                          decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.workspace_premium,
                            size: isMinimized ? 14 : 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedWelcomeText() {
    return FutureBuilder<Map<String, dynamic>>(
      future: UserService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!['name'] != null) {
          final name = snapshot.data!['name'] as String;
          return Text(
            "Bem-vindo, $name",
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
    );
  }

  Widget _buildAnimatedBadge() {
    return Container(
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
    );
  }

  Widget _buildPlanInfoRow() {
    return FutureBuilder<String?>(
      future: _loadPlan(),
      builder: (context, snapshot) {
        final plan = snapshot.data;
        final isPremium = plan == 'premium';
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (isPremium ? const Color(0xFFFFF3CD) : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPremium ? const Color(0xFFB7791F) : const Color(0xFFCBD5E0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPremium ? Icons.workspace_premium : Icons.lock_open,
                    size: 16,
                    color: isPremium ? const Color(0xFFB7791F) : const Color(0xFF4A5568),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isPremium ? 'Plano: Premium' : 'Plano: Básico',
                    style: TextStyle(
                      color: isPremium ? const Color(0xFFB7791F) : const Color(0xFF4A5568),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => GoRouter.of(context).go('/pricing'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Trocar plano'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                  // Header with profile info - Animated
                  AnimatedBuilder(
                    animation: _headerAnimation ?? const AlwaysStoppedAnimation(1.0),
                    builder: (context, child) {
                      final scale = _headerAnimation?.value ?? 1.0;
                      final isMinimized = scale < 0.4;
                      
                      if (isMinimized) {
                        // Quando minimizado, mostra apenas o avatar pequeno no topo
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              _buildAnimatedAvatar(),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Perfil",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      // Quando expandido, mostra o cabeçalho completo
                      return Container(
                        padding: EdgeInsets.all(24 * scale),
                        child: Column(
                          children: [
                            SizedBox(height: 20 * scale),
                            const Text(
                              "Perfil",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 30 * scale),
                            _buildAnimatedAvatar(),
                            SizedBox(height: 20 * scale),
                            _buildAnimatedWelcomeText(),
                            SizedBox(height: 8 * scale),
                            _buildPlanInfoRow(),
                            SizedBox(height: 8 * scale),
                            _buildAnimatedBadge(),
                          ],
                        ),
                      );
                    },
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
                        controller: _scrollController,
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
                              icon: Icons.card_membership,
                              text: "Planos",
                              subtitle: "Veja os planos disponíveis",
                              onTap: () => availablePlans(context),
                            ),
                            const SizedBox(height: 20),
                            _buildMenuItem(
                              icon: Icons.swap_horiz,
                              text: "Trocar Plano",
                              subtitle: "Alterar seu plano atual",
                              onTap: () => availablePlans(context),
                            ),
                            const SizedBox(height: 20),
                            _buildMenuItem(
                              icon: Icons.history,
                              text: "Minhas Solicitações",
                              subtitle: "Histórico de solicitações",
                              onTap: () => navigateToMinhasSolicitacoes(context),
                            ),
                            const SizedBox(height: 20),
                            _buildMenuItem(
                              icon: Icons.star,
                              text: "Minhas Avaliações",
                              subtitle: "Avaliações recebidas",
                              onTap: () => navigateToMinhasAvaliacoes(context),
                            ),
                            const SizedBox(height: 20),
                            _buildMenuItem(
                              icon: Icons.description,
                              text: "Termos de Serviço",
                              subtitle: "Leia nossos termos",
                              onTap: () => navigateToTerms(context),
                            ),
                            const SizedBox(height: 20),
                            _buildMenuItem(
                              icon: Icons.contact_support,
                              text: "Contato",
                              subtitle: "Entre em contato conosco",
                              onTap: () => navigateToContact(context),
                            ),
                            const SizedBox(height: 20),
                            _buildMenuItem(
                              icon: Icons.logout,
                              text: "Sair",
                              subtitle: "Fazer logout da conta",
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
          const FloatingMapButton(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 3),
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
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isLogout ? const Color(0xFFE53E3E).withOpacity(0.1) : const Color(0xFF3182CE).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isLogout ? const Color(0xFFE53E3E) : const Color(0xFF3182CE),
                      size: 24,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isLogout ? const Color(0xFFE53E3E) : const Color(0xFF2D3748),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: isLogout ? const Color(0xFFE53E3E).withOpacity(0.7) : const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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

void navigateToMinhasAvaliacoes(BuildContext context) {
  GoRouter.of(context).go('/minhas-avaliacoes');
}
