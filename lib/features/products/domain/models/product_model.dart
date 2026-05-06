import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int qty;

  @HiveField(4)
  final int maxQty;

  @HiveField(5)
  final int threshold;

  @HiveField(6)
  final String unit;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.qty,
    required this.maxQty,
    required this.threshold,
    required this.unit,
  });

  String get status {
    if (qty == 0) return 'Out of Stock';
    if (qty <= threshold) return 'Low Stock';
    return 'Optimal';
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    int? qty,
    int? maxQty,
    int? threshold,
    String? unit,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      qty: qty ?? this.qty,
      maxQty: maxQty ?? this.maxQty,
      threshold: threshold ?? this.threshold,
      unit: unit ?? this.unit,
    );
  }
}
