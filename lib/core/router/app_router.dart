import 'app_routes.dart';
import '../../presentation/main_layout/main_layout_screen.dart';
import '../../presentation/pages/cart_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/forgot_password_page.dart';
import '../../presentation/pages/home_screen.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/onboarding_page.dart';
import '../../presentation/pages/product_details_page.dart';
import '../../presentation/pages/register_page.dart';
import '../../presentation/pages/search_product_page.dart';
import '../../presentation/pages/splash_screen.dart';
import '../../presentation/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _wishlistNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'wishlist');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

@Riverpod(keepAlive: true)
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

      GoRoute(path: AppRoutes.cart, builder: (context, state) => const CartPage()),

      GoRoute(
        path: AppRoutes.prodDetails,
        name: AppRoutes.prodDetailsName,
        builder: (context, state) {
          final idString = state.pathParameters['id'];
          if (idString == null) throw Exception('Product ID is missing');
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

          StatefulShellBranch(
            navigatorKey: _wishlistNavigatorKey,
            routes: [
              GoRoute(path: AppRoutes.wishlist, builder: (context, state) => const WishlistPage()),
            ],
          ),
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
