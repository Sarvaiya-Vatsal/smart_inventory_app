import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/providers/products_provider.dart';

class AlertModel {
  final String id;
  final String productName;
  final String type; // 'critical' or 'low'
  final String message;

  AlertModel({
    required this.id,
    required this.productName,
    required this.type,
    required this.message,
  });
}

final alertsProvider = Provider<List<AlertModel>>((ref) {
  final products = ref.watch(productsProvider);
  final alerts = <AlertModel>[];

  for (final product in products) {
    if (product.qty == 0) {
      alerts.add(AlertModel(
        id: product.id,
        productName: product.name,
        type: 'critical',
        message: '🚨 Critical: Immediate restock required',
      ));
    } else if (product.qty <= product.threshold) {
      alerts.add(AlertModel(
        id: product.id,
        productName: product.name,
        type: 'low',
        message: '⚠️ Low stock: Restock soon',
      ));
    }
  }

  return alerts;
});
