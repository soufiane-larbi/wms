class WarehouseType {
  int? id;
  String? name, location, description;
  DateTime? creationDate, modifiedDate;

  WarehouseType({
    this.id,
    this.name,
    this.location,
    this.description,
    this.creationDate,
    this.modifiedDate,
  });
  @override
  bool operator ==(Object other) {
    return other is WarehouseType && id == other.id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static WarehouseType fromJson(Map<String, dynamic> json) {
    return WarehouseType(
      id: json['id'],
      name: json['name'],
    );
  }
}
