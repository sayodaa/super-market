import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mahmoud_hassan/core/router/app_router.dart';
import 'package:mahmoud_hassan/features/home/data/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ProductAdapter());

  // await Hive.deleteBoxFromDisk('products');

  await Hive.openBox<Product>('products');

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
