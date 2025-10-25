import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:instacar/presentation/pages/auth/register_page.dart';
import 'package:instacar/presentation/pages/chat/chat_list_page.dart';
import 'package:instacar/presentation/pages/main/caronas_page.dart';
import 'package:instacar/presentation/pages/main/favorites_page.dart';
import 'package:instacar/presentation/pages/auth/password_reset.dart';
import 'package:instacar/presentation/pages/main/plans.dart';
import '../presentation/pages/main/contact_page.dart';
import '../presentation/pages/main/home_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/code_page.dart';
import '../presentation/pages/auth/set_password.dart';
import '../presentation/pages/main/profile_page.dart';
import '../core/services/user_service.dart';

import '../presentation/pages/main/edit_profile_page.dart';
import '../presentation/pages/main/terms_page.dart';
import '../presentation/pages/main/pricing_page.dart';
import '../presentation/pages/main/ride_details_page.dart';
import '../presentation/pages/motorista/solicitacoes_page.dart';
import '../presentation/pages/usuario/minhas_solicitacoes_page.dart';
import '../presentation/pages/main/map_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/favorites',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: FavoritesPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/forgot',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ForgotPasswordPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/code',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: CodePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/reset',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: PasswordReset(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/set',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: SetPassword(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: FutureBuilder<String?>(
          future: UserService.getCurrentUserId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return ChatListPage(userId: snapshot.data ?? "unknown");
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: "/register",
      pageBuilder: (context, state) {
        final plan = state.uri.queryParameters['plan'];
        return CustomTransitionPage(
          child: RegisterPage(selectedPlan: plan),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const UserProfilePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/terms',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: TermosDeServicoPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/plans',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: PlansPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/contact',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: FeedbackPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/caronas',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: CaronasPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/pricing',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const PricingPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/ride-details/:rideId',
      pageBuilder: (context, state) {
        final rideId = state.pathParameters['rideId']!;
        return CustomTransitionPage(
          child: RideDetailsPage(rideId: rideId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/solicitacoes',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: SolicitacoesPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/minhas-solicitacoes',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: MinhasSolicitacoesPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/map',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const MapPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
  ],
);
