import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mahmoud_hassan/core/app/app_cubit/app_cubit.dart';
import 'package:mahmoud_hassan/core/router/app_router.dart';
import 'package:mahmoud_hassan/core/local_data/product.dart';
import 'package:mahmoud_hassan/features/customers/data/models/debt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ProductAdapter());

  // await Hive.deleteBoxFromDisk('products');

  await Hive.openBox<Product>('products');
  Hive.registerAdapter(DebtAdapter());
  await Hive.openBox<Debt>('debts');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
      ),
    );
  }
}
