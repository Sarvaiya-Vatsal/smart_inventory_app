import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'hive_service.dart';
import '../models/sync_item.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();
  bool _isSyncing = false;

  void init() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        debugPrint('[SyncService] Connectivity restored — triggering sync');
        syncPendingItems();
      }
    });
    syncPendingItems();
  }

  Future<void> addToQueue(String operation, String collection, Map<String, dynamic> data) async {
    final item = SyncItem(
      id: const Uuid().v4(),
      operation: operation,
      collection: collection,
      payload: jsonEncode(data),
      timestamp: DateTime.now(),
    );
    await HiveService.syncQueueBox.put(item.id, item);
    debugPrint('[SyncService] Queued [$operation] on [$collection] — queue size: ${HiveService.syncQueueBox.length}');
    syncPendingItems();
  }

  Future<void> syncPendingItems() async {
    if (_isSyncing) return;

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.isEmpty || connectivityResult.first == ConnectivityResult.none) {
      debugPrint('[SyncService] Offline — sync deferred');
      return;
    }

    _isSyncing = true;
    int successCount = 0;
    int failCount = 0;

    try {
      final pendingItems = HiveService.syncQueueBox.values.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      if (pendingItems.isEmpty) {
        debugPrint('[SyncService] No pending items to sync');
        return;
      }

      debugPrint('[SyncService] Starting sync — ${pendingItems.length} item(s) pending');

      for (final item in pendingItems) {
        final success = await _processItem(item);
        if (success) {
          await HiveService.syncQueueBox.delete(item.id);
          successCount++;
          debugPrint('[SyncService] ✅ Synced [${item.operation}] on [${item.collection}] (id: ${item.id})');
        } else {
          failCount++;
          debugPrint('[SyncService] ❌ Failed [${item.operation}] on [${item.collection}] (id: ${item.id}) — will retry later');
        }
      }

      debugPrint('[SyncService] Sync complete — $successCount succeeded, $failCount failed');

      if (HiveService.syncQueueBox.isEmpty) {
        debugPrint('[SyncService] ✅ Queue cleared — all items synced to Firebase');
      }
    } catch (e) {
      debugPrint('[SyncService] Unexpected error during sync: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _processItem(SyncItem item) async {
    try {
      final payload = item.getPayloadMap();
      final docId = payload['id']?.toString() ?? item.id;
      final docRef = _firestore.collection(item.collection).doc(docId);

      if (item.operation == 'delete') {
        await docRef.delete();
      } else if (item.operation == 'add' || item.operation == 'update') {
        await docRef.set(payload, SetOptions(merge: true));
      }
      return true;
    } catch (e) {
      debugPrint('[SyncService] _processItem error: $e');
      return false;
    }
  }
}
