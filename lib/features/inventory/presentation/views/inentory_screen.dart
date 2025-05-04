import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mahmoud_hassan/core/local_data/product.dart';
import 'package:mahmoud_hassan/features/inventory/presentation/widgets/inventory_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Box<Product> productBox;

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('products');
  }

  @override
  Widget build(BuildContext context) {
    final products = productBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body:
          products.isEmpty
              ? const Center(child: Text('No products in inventory.'))
              : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InventoryItem(
                    product: product,
                    onDelete: () {
                      setState(() {
                        productBox.deleteAt(index);
                      });
                    },
                  );
                },
              ),
    );
  }
}
