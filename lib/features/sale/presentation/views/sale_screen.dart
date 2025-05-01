import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mahmoud_hassan/features/home/data/product.dart';

// ignore: use_key_in_widget_constructors
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _quantityUnitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة منتج")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'اسم المنتج'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'السعر'),
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'الكمية'),
            ),
            TextField(
              controller: _quantityUnitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'عدد الوحدات'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final price = double.tryParse(_priceController.text) ?? 0;
                final quantity = int.tryParse(_quantityController.text) ?? 0;
                final quantityUnit =
                    int.tryParse(_quantityUnitController.text)??0;
                if (name.isNotEmpty && price > 0 && quantity > 0) {
                  final product = Product(
                    name: name,
                    price: price,
                    quantityUnit: quantityUnit,
                    quantity: quantity,
                  );
                  final box = Hive.box<Product>('products');
                  box.add(product);

                  Navigator.pop(context);
                } else {
                  // إذا كانت المدخلات غير صحيحة، عرض رسالة
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال بيانات صحيحة.')),
                  );
                }
              },
              child: const Text('حفظ المنتج'),
            ),
          ],
        ),
      ),
    );
  }
}
