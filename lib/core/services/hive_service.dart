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

    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(StockHistoryModelAdapter());
    Hive.registerAdapter(SyncItemAdapter());

    await Hive.openBox<ProductModel>(productsBoxName);
    await Hive.openBox<StockHistoryModel>(historyBoxName);
    await Hive.openBox<SyncItem>(syncQueueBoxName);
  }

  static Box<ProductModel> get productsBox => Hive.box<ProductModel>(productsBoxName);
  static Box<StockHistoryModel> get historyBox => Hive.box<StockHistoryModel>(historyBoxName);
  static Box<SyncItem> get syncQueueBox => Hive.box<SyncItem>(syncQueueBoxName);
}
