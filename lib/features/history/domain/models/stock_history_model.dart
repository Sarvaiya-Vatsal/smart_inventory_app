import 'package:hive/hive.dart';

part 'stock_history_model.g.dart';

@HiveType(typeId: 1)
class StockHistoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final int change;

  @HiveField(4)
  final DateTime timestamp;

  StockHistoryModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.change,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'change': change,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StockHistoryModel.fromMap(Map<String, dynamic> map) {
    return StockHistoryModel(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      change: map['change']?.toInt() ?? 0,
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
