import 'dart:io';

import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  int quantityUnit;

  @HiveField(4)
  double priceBuy;

  @HiveField(5)
  String? image;

  Product({
    required this.quantityUnit,
    required this.priceBuy,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });
}
