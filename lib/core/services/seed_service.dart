import '../../../features/products/domain/models/product_model.dart';
import 'hive_service.dart';
import 'sync_service.dart';

class SeedService {
  static Future<void> seedDemoProducts() async {
    if (HiveService.productsBox.isNotEmpty) return;

    final products = [
      ProductModel(
        id: 'seed-001',
        name: 'Ball Point Pens',
        category: 'Consumables',
        qty: 120,
        maxQty: 200,
        threshold: 30,
        unit: 'pcs',
      ),
      ProductModel(
        id: 'seed-002',
        name: 'A4 Notebooks',
        category: 'Consumables',
        qty: 85,
        maxQty: 150,
        threshold: 20,
        unit: 'pcs',
      ),
      ProductModel(
        id: 'seed-003',
        name: 'Wireless Mouse',
        category: 'Equipment',
        qty: 14,
        maxQty: 50,
        threshold: 5,
        unit: 'pcs',
      ),
      ProductModel(
        id: 'seed-004',
        name: 'Glass Test Tubes',
        category: 'Glassware',
        qty: 18,
        maxQty: 100,
        threshold: 20,
        unit: 'pcs',
      ),
      ProductModel(
        id: 'seed-005',
        name: 'Micropipette Tips',
        category: 'Consumables',
        qty: 40,
        maxQty: 500,
        threshold: 50,
        unit: 'pcs',
      ),
      ProductModel(
        id: 'seed-006',
        name: 'Basmati Rice',
        category: 'Packaging',
        qty: 8,
        maxQty: 100,
        threshold: 10,
        unit: 'kg',
      ),
      ProductModel(
        id: 'seed-007',
        name: 'Refined Sugar',
        category: 'Packaging',
        qty: 5,
        maxQty: 80,
        threshold: 10,
        unit: 'kg',
      ),
      ProductModel(
        id: 'seed-008',
        name: 'Latex Gloves',
        category: 'Consumables',
        qty: 0,
        maxQty: 200,
        threshold: 25,
        unit: 'pairs',
      ),
      ProductModel(
        id: 'seed-009',
        name: 'Hand Sanitizer',
        category: 'Chemicals',
        qty: 0,
        maxQty: 60,
        threshold: 10,
        unit: 'bottles',
      ),
      ProductModel(
        id: 'seed-010',
        name: 'USB Keyboard',
        category: 'Equipment',
        qty: 0,
        maxQty: 30,
        threshold: 5,
        unit: 'pcs',
      ),
    ];

    for (final product in products) {
      await HiveService.productsBox.put(product.id, product);
      await SyncService().addToQueue('add', 'products', product.toMap());
    }
  }
}
