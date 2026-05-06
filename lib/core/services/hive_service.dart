import 'package:hive_flutter/hive_flutter.dart';
import '../../features/products/domain/models/product_model.dart';
import '../../features/history/domain/models/stock_history_model.dart';
import '../models/sync_item.dart';

class HiveService {
  static const String productsBoxName = 'productsBox';
  static const String historyBoxName = 'historyBox';
  static const String syncQueueBoxName = 'syncQueueBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProductModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(StockHistoryModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(SyncItemAdapter());

    if (!Hive.isBoxOpen(productsBoxName)) {
      await Hive.openBox<ProductModel>(productsBoxName);
    }
    if (!Hive.isBoxOpen(historyBoxName)) {
      await Hive.openBox<StockHistoryModel>(historyBoxName);
    }
    if (!Hive.isBoxOpen(syncQueueBoxName)) {
      await Hive.openBox<SyncItem>(syncQueueBoxName);
    }
  }

  static Box<ProductModel> get productsBox => Hive.box<ProductModel>(productsBoxName);
  static Box<StockHistoryModel> get historyBox => Hive.box<StockHistoryModel>(historyBoxName);
  static Box<SyncItem> get syncQueueBox => Hive.box<SyncItem>(syncQueueBoxName);
}
