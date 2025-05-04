// lib/core/router/router.dart

import 'package:go_router/go_router.dart';
import 'package:mahmoud_hassan/core/router/route_names.dart';
import 'package:mahmoud_hassan/features/home/presentation/views/home_screen.dart';
import 'package:mahmoud_hassan/features/inventory/presentation/views/inentory_screen.dart';
import 'package:mahmoud_hassan/features/purchases/presentation/views/purchases_screens.dart';
import 'package:mahmoud_hassan/features/sale/presentation/views/sale_screen.dart';

final router = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteNames.sales,
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: RouteNames.inventory,
      builder: (context, state) => const InventoryScreen(),
    ),
    GoRoute(
      path: RouteNames.purchases,
      builder: (context, state) => const PurchasesScreens(),
    ),
  ],
);
