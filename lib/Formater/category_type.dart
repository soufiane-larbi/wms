import 'package:mysql1/mysql1.dart';

class CategoryType {
  int? id;
  String? name;
  Blob? image;
  DateTime? creationDate, modifiedDate;
  CategoryType({
    this.id,
    this.creationDate,
    this.image,
    this.modifiedDate,
    this.name,
  });

  @override
  bool operator ==(Object other) {
    return other is CategoryType && id == other.id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static CategoryType fromJson(Map<String, dynamic> json) {
    return CategoryType(
      id: json['id'],
      name: json['name'],
    );
  }
}
