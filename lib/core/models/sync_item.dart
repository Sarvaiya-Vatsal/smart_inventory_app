import 'package:hive/hive.dart';
import 'dart:convert';

part 'sync_item.g.dart';

@HiveType(typeId: 2)
class SyncItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String operation; // 'add', 'update', 'delete'

  @HiveField(2)
  final String collection; // 'products', 'stock_history'

  @HiveField(3)
  final String payload; // JSON string of the data

  @HiveField(4)
  final DateTime timestamp;

  SyncItem({
    required this.id,
    required this.operation,
    required this.collection,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> getPayloadMap() {
    if (payload.isEmpty) return {};
    return jsonDecode(payload) as Map<String, dynamic>;
  }
}
