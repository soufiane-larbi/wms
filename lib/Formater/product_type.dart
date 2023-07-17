import 'package:mysql1/mysql1.dart';
import 'package:whm/Formater/warehouse_type.dart';

import 'category_type.dart';

class ProductType {
  int? id;
  String? name, unit, barcode, inventory;
  CategoryType? category;
  WarehouseType? warehouse;
  DateTime? creationDate, modifiedDate;
  Blob? image;
  double? quantity, price, remove = 0;
  ProductType({
    this.id,
    this.name,
    this.unit,
    this.barcode,
    this.image,
    this.category,
    this.warehouse,
    this.creationDate,
    this.modifiedDate,
    this.quantity,
    this.price,
    this.inventory,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'barcode': barcode,
      'category': category,
      'warehouse': warehouse,
      'quantity': quantity,
      'inventory': inventory,
      'price': price,
    };
  }

  static ProductType fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      barcode: json['barcode'],
      quantity: json['quantity'],
      inventory: json['inventory'],
      price: json['price'],
      category: CategoryType.fromJson(json['category']),
      warehouse: WarehouseType.fromJson(json['warehouse']),
    );
  }

  void updateQuantity(double remove) {
    this.remove = remove;
  }
}
