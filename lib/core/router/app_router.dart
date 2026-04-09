import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/presentation/main_layout/main_layout_screen.dart';
import 'package:eliza_beauty/presentation/pages/cart_page.dart';
import 'package:eliza_beauty/presentation/pages/profile_page.dart';
import 'package:eliza_beauty/presentation/pages/forgot_password_page.dart';
import 'package:eliza_beauty/presentation/pages/home_screen.dart';
import 'package:eliza_beauty/presentation/pages/login_page.dart';
import 'package:eliza_beauty/presentation/pages/onboarding_page.dart';
import 'package:eliza_beauty/presentation/pages/product_details_page.dart';
import 'package:eliza_beauty/presentation/pages/register_page.dart';
import 'package:eliza_beauty/presentation/pages/search_product_page.dart';
import 'package:eliza_beauty/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      GoRoute(path: AppRoutes.cart, builder: (context, state) => CartPage()),

      GoRoute(
        path: AppRoutes.prodDetails,
        name: AppRoutes.prodDetailsName,
        builder: (context, state) {
          final idString = state.pathParameters['id'];
          if (idString == null) throw Exception("Product ID is missing");
          return ProductDetailsPage(productId: int.parse(idString));
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayoutScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _searchNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchProductPage(),
              ),
            ],
          ),

          // StatefulShellBranch(
          //   navigatorKey: _saveNavigatorKey,
          //   routes: [
          //     GoRoute(path: AppRoutes.cart, builder: (context, state) => CartPage()),
          //   ],
          // ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
