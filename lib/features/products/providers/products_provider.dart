import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/hive_service.dart';
import '../domain/models/product_model.dart';
import '../../history/providers/history_provider.dart';
import '../../../core/services/sync_service.dart';

class ProductsNotifier extends Notifier<List<ProductModel>> {
  @override
  List<ProductModel> build() {
    return HiveService.productsBox.values.toList();
  }

  void addProduct(ProductModel product) {
    HiveService.productsBox.put(product.id, product);
    SyncService().addToQueue('add', 'products', product.toMap());
    state = [...state, product];
  }

  void updateProduct(ProductModel product) {
    HiveService.productsBox.put(product.id, product);
    SyncService().addToQueue('update', 'products', product.toMap());
    state = [
      for (final p in state)
        if (p.id == product.id) product else p
    ];
  }

  void deleteProduct(String id) {
    HiveService.productsBox.delete(id);
    SyncService().addToQueue('delete', 'products', {'id': id});
    ref.read(historyProvider.notifier).deleteLogsForProduct(id);
    state = state.where((p) => p.id != id).toList();
  }

  String? stockIn(String id, int amount) {
    if (amount <= 0) return 'Amount must be greater than zero';

    final product = state.firstWhere((p) => p.id == id,
        orElse: () => throw Exception('Product not found'));

    final updatedProduct = product.copyWith(qty: product.qty + amount);
    updateProduct(updatedProduct);

    ref.read(historyProvider.notifier).logMovement(
          productId: id,
          productName: product.name,
          change: amount,
        );

    return null;
  }

  String? stockOut(String id, int amount) {
    if (amount <= 0) return 'Amount must be greater than zero';

    final product = state.firstWhere((p) => p.id == id,
        orElse: () => throw Exception('Product not found'));

    if (product.qty < amount) return 'Insufficient stock';

    final updatedProduct = product.copyWith(qty: product.qty - amount);
    updateProduct(updatedProduct);

    ref.read(historyProvider.notifier).logMovement(
          productId: id,
          productName: product.name,
          change: -amount,
        );

    return null;
  }
}

final productsProvider = NotifierProvider<ProductsNotifier, List<ProductModel>>(() {
  return ProductsNotifier();
});
