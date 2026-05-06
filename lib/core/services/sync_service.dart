import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    syncPendingItems();
  }

  Future<void> syncPendingItems() async {
    if (_isSyncing) return;
    
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.isEmpty || connectivityResult.first == ConnectivityResult.none) return;

    _isSyncing = true;
    try {
      final pendingItems = HiveService.syncQueueBox.values.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      for (var item in pendingItems) {
        bool success = await _processItem(item);
        if (success) {
          await HiveService.syncQueueBox.delete(item.id);
        } else {
          break;
        }
      }
    } catch (e) {
      // Keep errors silent for offline persistence
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
      return false;
    }
  }
}
