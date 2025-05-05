import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mahmoud_hassan/core/app/app_cubit/app_cubit.dart';
import 'package:mahmoud_hassan/core/local_data/product.dart';

class PurchasesScreens extends StatefulWidget {
  const PurchasesScreens({super.key});

  @override
  _PurchasesScreensState createState() => _PurchasesScreensState();
}

class _PurchasesScreensState extends State<PurchasesScreens> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _quantityUnitController = TextEditingController();
  final _priceBuyUnitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var productImage = AppCubit.get(context).productImage;
        return Scaffold(
          appBar: AppBar(title: const Text("اضافة منتج مشترى")),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.blue.shade100,
                        foregroundImage:
                            productImage != null
                                ? FileImage(productImage)
                                : AssetImage('assets/images/empty_screen.png')
                                    as ImageProvider, //null or install image asset
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            AppCubit.get(context).pickProductImage();
                          },
                          icon: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.camera_alt_outlined, size: 24.0),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  TextField(
                    controller: _priceBuyUnitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'سعر الشراء'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveProduct,
                    child: const Text('حفظ المنتج'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // التحقق من وجود المنتج وإرجاع مؤشره إذا كان موجوداً
  int? findProductIndex(String productName) {
    final box = Hive.box<Product>('products');

    // البحث عن المنتج بنفس الاسم (مع تجاهل حالة الأحرف)
    for (int i = 0; i < box.length; i++) {
      final product = box.getAt(i);
      if (product != null &&
          product.name.trim().toLowerCase() ==
              productName.trim().toLowerCase()) {
        return i;
      }
    }
    return null; // إرجاع null إذا لم يتم العثور على المنتج
  }

  void saveProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final quantityUnit = int.tryParse(_quantityUnitController.text) ?? 0;
    final priceBuy = double.tryParse(_priceBuyUnitController.text) ?? 0;
    final image = AppCubit.get(context).productImage;

    // التحقق من صحة المدخلات
    if (name.isEmpty || price <= 0 || quantity <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال بيانات صحيحة.')));
      return;
    }

    final box = Hive.box<Product>('products');
    final existingProductIndex = findProductIndex(name);

    // إذا كان المنتج موجوداً بالفعل، يتم زيادة الكمية
    if (existingProductIndex != null) {
      // الحصول على المنتج الموجود
      final existingProduct = box.getAt(existingProductIndex)!;

      // تحديث بيانات المنتج مع زيادة الكمية
      final updatedProduct = Product(
        name: existingProduct.name,
        price:
            price, // يمكن الاحتفاظ بالسعر الجديد أو استخدام القديم: existingProduct.price
        quantityUnit:
            quantityUnit, // يمكن تحديث أو الاحتفاظ بالقديم: existingProduct.quantityUnit
        quantity: existingProduct.quantity + quantity, // زيادة الكمية
        priceBuy:
            priceBuy, // يمكن تحديث أو الاحتفاظ بالقديم: existingProduct.priceBuy
        image:
            image?.path ??
            existingProduct
                .image, // استخدام الصورة الجديدة إذا كانت متوفرة، وإلا استخدام القديمة
      );

      // تحديث المنتج في المخزن
      box.putAt(existingProductIndex, updatedProduct);

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تحديث كمية المنتج "$name" بنجاح! (الكمية الكلية: ${updatedProduct.quantity})',
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // إضافة منتج جديد إذا لم يكن موجوداً
      final newProduct = Product(
        name: name,
        price: price,
        quantityUnit: quantityUnit,
        quantity: quantity,
        priceBuy: priceBuy,
        image: image?.path ?? '',
      );

      // إضافة المنتج الجديد
      box.add(newProduct);

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة المنتج "$name" بنجاح!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // مسح الحقول بعد الإضافة أو التحديث
    _clearFields();

    // العودة للشاشة السابقة
    Navigator.pop(context);
  }

  // دالة لمسح حقول الإدخال
  void _clearFields() {
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    _quantityUnitController.clear();
    _priceBuyUnitController.clear();
    AppCubit.get(context).removeProductImage();
  }

  @override
  void dispose() {
    // تحرير الموارد
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _quantityUnitController.dispose();
    _priceBuyUnitController.dispose();
    super.dispose();
  }

  // bool isProductExist(String productName) {
  //   final box = Hive.box<Product>('products');
  //   for (int i = 0; i < box.length; i++) {
  //     final product = box.getAt(i);
  //     if (product != null &&
  //         product.name.trim().toLowerCase() ==
  //             productName.trim().toLowerCase()) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }
  // void saveProduct() {
  //   final name = _nameController.text;
  //   final price = double.tryParse(_priceController.text) ?? 0;
  //   final quantity = int.tryParse(_quantityController.text) ?? 0;
  //   final quantityUnit = int.tryParse(_quantityUnitController.text) ?? 0;
  //   final priceBuy = double.tryParse(_priceBuyUnitController.text) ?? 0;
  //   final image = AppCubit.get(context).productImage;
  //   if (name.isEmpty || price <= 0 || quantity <= 0) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('يرجى إدخال بيانات صحيحة.')));
  //     return;
  //   }
  //   if (isProductExist(name)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('المنتج "$name" موجود بالفعل!'),
  //         backgroundColor: Colors.orange,
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //     return;
  //   }
  //   final product = Product(
  //     name: name,
  //     price: price,
  //     quantityUnit: quantityUnit,
  //     quantity: quantity,
  //     priceBuy: priceBuy,
  //     image: image?.path ?? '',
  //   );
  //   final box = Hive.box<Product>('products');
  //   box.add(product);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('تم إضافة المنتج "$name" بنجاح!'),
  //       backgroundColor: Colors.green,
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  //   Navigator.pop(context);
  // }
  // @override
  // void dispose() {
  //   // تحرير الموارد
  //   _nameController.dispose();
  //   _priceController.dispose();
  //   _quantityController.dispose();
  //   _quantityUnitController.dispose();
  //   _priceBuyUnitController.dispose();
  //   super.dispose();
  // }
}
