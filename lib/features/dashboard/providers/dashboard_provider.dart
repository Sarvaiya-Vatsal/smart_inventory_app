import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/providers/products_provider.dart';
import '../../history/providers/history_provider.dart';

final totalProductsProvider = Provider<int>((ref) {
  final products = ref.watch(productsProvider);
  return products.length;
});

final lowStockCountProvider = Provider<int>((ref) {
  final products = ref.watch(productsProvider);
  return products.where((p) => p.status == 'Low Stock').length;
});

final outOfStockCountProvider = Provider<int>((ref) {
  final products = ref.watch(productsProvider);
  return products.where((p) => p.status == 'Out of Stock').length;
});

final recentUpdatesProvider = Provider((ref) {
  final history = ref.watch(historyProvider);
  return history.take(5).toList();
});
