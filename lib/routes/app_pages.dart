import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoply/modules/cart/cart_page.dart';
import 'package:shoply/modules/home/home_page.dart';
import 'package:shoply/modules/profile/profile_page.dart';

import '../modules/favorites/favorites_page.dart';
import '../modules/login/login_page.dart';
import '../widgets/custom_scaffold.dart'; // Yeni eklenen import

abstract class AppRoutes {
  static const INITIAL = LOGIN;
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const FAVORITES = '/favorites';
  static const CART = '/cart';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.LOGIN,
  routes: [
    GoRoute(
      path: AppRoutes.LOGIN,
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        String title = "Shoply"; // Varsayılan başlık

        // Mevcut rotaya göre başlığı belirle
        switch (state.uri.path) {
          case AppRoutes.HOME:
            title = "Shoply";
            break;
          case AppRoutes.CART:
            title = "Sepetim";
            break;
          case AppRoutes.FAVORITES:
            title = "Favorilerim";
            break;
          case AppRoutes.PROFILE:
            title = "Profilim";
            break;
        }

        return CustomScaffold(
          title: title,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.HOME,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.CART,
          builder: (context, state) => const CartPage(),
        ),
        GoRoute(
          path: AppRoutes.FAVORITES,
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: AppRoutes.PROFILE,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);