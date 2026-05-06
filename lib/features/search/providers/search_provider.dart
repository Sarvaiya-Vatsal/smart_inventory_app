import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/domain/models/product_model.dart';
import '../../products/providers/products_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchFilterProvider = StateProvider<String>((ref) => 'All');

final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filter = ref.watch(searchFilterProvider);

  return products.where((product) {
    final matchesQuery = product.name.toLowerCase().contains(query) ||
        product.category.toLowerCase().contains(query);

    bool matchesFilter = true;
    if (filter != 'All') {
      if (filter == 'Low Stock') {
        matchesFilter = product.status == 'Low Stock';
      } else if (filter == 'Out of Stock') {
        matchesFilter = product.status == 'Out of Stock';
      } else if (filter == 'Optimal') {
        matchesFilter = product.status == 'Optimal';
      } else {
        matchesFilter = product.category == filter;
      }
    }

    return matchesQuery && matchesFilter;
  }).toList();
});
