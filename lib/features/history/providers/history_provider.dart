import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/hive_service.dart';
import '../domain/models/stock_history_model.dart';
import '../../../core/services/sync_service.dart';

class HistoryNotifier extends Notifier<List<StockHistoryModel>> {
  @override
  List<StockHistoryModel> build() {
    final logs = HiveService.historyBox.values.toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  void logMovement({
    required String productId,
    required String productName,
    required int change,
  }) {
    final log = StockHistoryModel(
      id: const Uuid().v4(),
      productId: productId,
      productName: productName,
      change: change,
      timestamp: DateTime.now(),
    );

    HiveService.historyBox.put(log.id, log);
    SyncService().addToQueue('add', 'stock_history', log.toMap());
    state = [log, ...state];
  }

  void deleteLogsForProduct(String productId) {
    final logsToDelete = HiveService.historyBox.values
        .where((log) => log.productId == productId)
        .toList();

    for (final log in logsToDelete) {
      HiveService.historyBox.delete(log.id);
      SyncService().addToQueue('delete', 'stock_history', {'id': log.id});
    }

    state = state.where((log) => log.productId != productId).toList();
  }
}

final historyProvider =
    NotifierProvider<HistoryNotifier, List<StockHistoryModel>>(() {
  return HistoryNotifier();
});
