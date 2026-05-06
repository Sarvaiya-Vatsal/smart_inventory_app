import 'package:hive_flutter/hive_flutter.dart';
import '../../features/products/domain/models/product_model.dart';
import '../../features/history/domain/models/stock_history_model.dart';

class HiveService {
  static const String productsBoxName = 'productsBox';
  static const String historyBoxName = 'historyBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(StockHistoryModelAdapter());

    await Hive.openBox<ProductModel>(productsBoxName);
    await Hive.openBox<StockHistoryModel>(historyBoxName);
  }

  static Box<ProductModel> get productsBox => Hive.box<ProductModel>(productsBoxName);
  static Box<StockHistoryModel> get historyBox => Hive.box<StockHistoryModel>(historyBoxName);
}
