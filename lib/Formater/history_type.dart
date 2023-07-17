import 'package:whm/Formater/product_type.dart';

class HistoryType {
  int? id;
  String? user;
  ProductType? productOld, productNew;
  DateTime? date;
  HistoryType({
    this.id,
    this.user,
    this.productOld,
    this.productNew,
    this.date,
  });

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is HistoryType && id == other.id;
  }
}
