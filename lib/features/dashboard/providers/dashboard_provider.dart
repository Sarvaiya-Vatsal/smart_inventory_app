import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'totalProducts': 124,
    'lowStockCount': 12,
    'recentlyUpdated': 5,
  };
});
