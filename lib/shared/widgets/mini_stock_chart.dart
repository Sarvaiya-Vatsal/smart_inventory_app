import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../features/history/providers/history_provider.dart';

class MiniStockChart extends ConsumerWidget {
  final String productId;
  final int currentQty;
  final Color color;

  const MiniStockChart({
    super.key,
    required this.productId,
    required this.currentQty,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyLogs = ref.watch(historyProvider);

    // Get the most recent 10 logs for this product (historyProvider is sorted newest first)
    final productLogs = historyLogs.where((log) => log.productId == productId).take(10).toList();

    // If there's no history, just show a flat line
    if (productLogs.isEmpty) {
      return SizedBox(
        height: 60,
        child: LineChart(
          _buildChartData([
            FlSpot(0, currentQty.toDouble()),
            FlSpot(1, currentQty.toDouble()),
          ], color),
        ),
      );
    }

    // We have recent logs. The end point is the currentQty.
    // Calculate backwards to find historical quantities.
    int tempQty = currentQty;
    final List<int> historicalQtys = [currentQty];

    for (int i = 0; i < productLogs.length; i++) {
      tempQty = tempQty - productLogs[i].change;
      historicalQtys.insert(0, tempQty);
    }

    // Now convert into FlSpots
    final spots = <FlSpot>[];
    for (int i = 0; i < historicalQtys.length; i++) {
      spots.add(FlSpot(i.toDouble(), historicalQtys[i].toDouble()));
    }

    return SizedBox(
      height: 60,
      child: LineChart(_buildChartData(spots, color)),
    );
  }

  LineChartData _buildChartData(List<FlSpot> spots, Color lineColor) {
    // Determine min/max Y for some padding
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (final spot in spots) {
      if (spot.y < minY) minY = spot.y;
      if (spot.y > maxY) maxY = spot.y;
    }

    if (minY == maxY) {
      minY -= 10;
      maxY += 10;
    } else {
      final padding = (maxY - minY) * 0.2;
      minY -= padding;
      maxY += padding;
    }
    
    if (minY < 0) minY = 0;

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: lineColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: index == spots.length - 1 ? 4 : 2,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: lineColor,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: lineColor.withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: const LineTouchData(enabled: false),
    );
  }
}
