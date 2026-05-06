import 'package:flutter/material.dart';

class StockStatusIndicator extends StatelessWidget {
  final String status;

  const StockStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'Low Stock':
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFD97706), size: 20),
        );
      case 'Out of Stock':
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDC2626)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.error_outline_rounded,
              color: Color(0xFFDC2626), size: 20),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF16A34A)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.check_circle_outline_rounded,
              color: Color(0xFF16A34A), size: 20),
        );
    }
  }
}
