import 'package:flutter/material.dart';
import 'package:mahmoud_hassan/core/router/route_names.dart';
import 'package:mahmoud_hassan/features/home/presentation/widgets/dash_board.dart';
import 'package:mahmoud_hassan/features/sale/presentation/views/sale_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محمود حسن')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("القائمة")),
            ListTile(
              title: const Text("المنتجات"),
              onTap: () => Navigator.pushNamed(context, "/products"),
            ),
            ListTile(
              title: const Text("المبيعات"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductScreen()),
                  ),
            ),
            ListTile(
              title: const Text("المشتريات"),
              onTap: () => Navigator.pushNamed(context, "/purchases"),
            ),
            ListTile(
              title: const Text("التقارير"),
              onTap: () => Navigator.pushNamed(context, "/reports"),
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          DashboardCard(
            title: "المبيعات",
            icon: Icons.attach_money,
            child: RouteNames.sales,
          ),
          DashboardCard(
            title: "المشتريات",
            icon: Icons.shopping_cart,
            child: RouteNames.sales,
          ),
          DashboardCard(
            title: "المخزن",
            icon: Icons.inventory,
            child: RouteNames.inventory,
          ),
          DashboardCard(
            title: "العملاء",
            icon: Icons.person,
            child: RouteNames.sales,
          ),
        ],
      ),
    );
  }
}
