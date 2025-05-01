import 'package:flutter/material.dart';
import 'package:mahmoud_hassan/features/home/data/product.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({
    super.key,
    required this.product,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final profit = ((product.quantityUnit * product.price) - product.priceBuy);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.inventory, color: Colors.blue),
            ),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اسم المنتج: ${product.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عدد العلب: ${product.quantity}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'عدد القطع في العلبة: ${product.quantityUnit}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'سعر شراء العلبة: ${product.priceBuy.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Price, Profit, and Delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'سعر القطعة:${product.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'مكسب العلبة:${profit.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: profit >= 0 ? Colors.blue.shade700 : Colors.red,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Delete ${product.name}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}