import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoply/modules/home/home_cubit.dart';
import 'package:shoply/routes/app_pages.dart';
import 'package:shoply/themes/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const CustomScaffold({
    super.key,
    required this.child,
    this.title = "Shoply",
  });

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final bool isHomePage = location.startsWith(AppRoutes.HOME);
    
    return Scaffold(
      body: child,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        gapLocation: GapLocation.none,
        backgroundColor: AppColors.white,
        activeIndex: _calculateSelectedIndex(context),
        splashColor: AppColors.secondary,
        activeColor: AppColors.primary,
        inactiveColor: Colors.black.withAlpha(100),
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        icons: const [
          Iconsax.home_2,
          Iconsax.shopping_cart,
          Iconsax.heart,
          Iconsax.user,
        ],
        onTap: (index) => _onItemTapped(index, context),
      ),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontFamily: "Outfitb"),
        ),
        actions: isHomePage ? [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return PopupMenuButton<String?>(
                icon: const Icon(Iconsax.category),
                onSelected: (String? category) {
                  context.read<HomeCubit>().filterByCategory(category);
                },
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<String?>> menuItems = [
                    const PopupMenuItem<String?>(
                      value: null,
                      child: Text('Tüm Kategoriler'),
                    ),
                    const PopupMenuDivider(),
                  ];
                  
                  menuItems.addAll(
                    state.categories.map(
                      (category) => PopupMenuItem<String?>(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                  );
                  
                  return menuItems;
                },
              );
            },
          ),
        ] : null,
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.HOME)) {
      return 0;
    }
    if (location.startsWith(AppRoutes.CART)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.FAVORITES)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.PROFILE)) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.HOME);
        break;
      case 1:
        context.go(AppRoutes.CART);
        break;
      case 2:
        context.go(AppRoutes.FAVORITES);
        break;
      case 3:
        context.go(AppRoutes.PROFILE);
        break;
    }
  }
}
