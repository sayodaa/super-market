import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mahmoud_hassan/core/common/widgets/costom_search_widget.dart';
import 'package:mahmoud_hassan/core/local_data/product.dart';
import 'package:mahmoud_hassan/features/inventory/presentation/widgets/inventory_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Box<Product> productBox;
  final _searchController = TextEditingController();

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('products');
    _loadProducts();
  }

  void _loadProducts() {
    allProducts = productBox.values.toList();
    filteredProducts = List.from(allProducts);
    setState(() {});
  }

  void _deleteProduct(int index) {
    final product = filteredProducts[index];
    final key = productBox.keys.firstWhere((k) => productBox.get(k) == product);
    productBox.delete(key);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: productBox.isEmpty
          ? const Center(child: Text('No products in inventory.'))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CustomSearchWidget(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        filteredProducts = allProducts
                            .where((product) => product.name
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: filteredProducts.length,
                    (context, index) {
                      final product = filteredProducts[index];
                      return InventoryItem(
                        product: product,
                        onDelete: () => _deleteProduct(index),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
