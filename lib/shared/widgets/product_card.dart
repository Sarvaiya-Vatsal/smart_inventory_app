import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'stock_status_indicator.dart';
import 'mini_stock_chart.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ProductCard({super.key, required this.item});

  Color _statusColor() {
    switch (item['status']) {
      case 'Low Stock':
        return const Color(0xFFD97706);
      case 'Out of Stock':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF16A34A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    final progress = item['max'] > 0
        ? (item['qty'] as int) / (item['max'] as int)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item['status'],
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_vert_rounded,
                  color: Color(0xFF9CA3AF), size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item['name'],
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D1B2A),
            ),
          ),
          Text(
            '${item['category']} • ${item['unit']}',
            style: GoogleFonts.inter(
                fontSize: 12, color: const Color(0xFF718096)),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item['qty']}',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: item['status'] == 'Out of Stock'
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF0D1B2A),
                          ),
                        ),
                        TextSpan(
                          text: ' / ${item['max']} ${item['unit']}',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              StockStatusIndicator(status: item['status']),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'STOCK TREND (Recent)',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          MiniStockChart(
            productId: item['id'],
            currentQty: item['qty'] as int,
            color: color,
          ),
          if (item['status'] == 'Low Stock' || item['status'] == 'Out of Stock')
            ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: Color(0xFF2563EB), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Suggested restock: ${((item['threshold'] as int) * 2) - (item['qty'] as int)} ${item['unit']}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}
