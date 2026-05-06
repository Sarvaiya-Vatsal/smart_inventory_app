import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/dashboard_info_card.dart';
import '../../providers/dashboard_provider.dart';
import '../../../alerts/presentation/widgets/notification_bell.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalProducts = ref.watch(totalProductsProvider);
    final lowStockCount = ref.watch(lowStockCountProvider);
    final outOfStockCount = ref.watch(outOfStockCountProvider);
    final recentUpdates = ref.watch(recentUpdatesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 24),
              DashboardInfoCard(
                icon: Icons.grid_view_rounded,
                iconColor: const Color(0xFF1A56DB),
                iconBg: const Color(0xFFEBF0FF),
                label: 'Total Products',
                value: '$totalProducts',
                badge: 'All Categories',
                borderColor: const Color(0xFF1A56DB),
              ),
              const SizedBox(height: 12),
              DashboardInfoCard(
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFFF7ED),
                label: 'Low Stock Items',
                value: '$lowStockCount',
                badge: 'Requires Action',
                borderColor: const Color(0xFFD97706),
              ),
              const SizedBox(height: 12),
              DashboardInfoCard(
                icon: Icons.error_outline_rounded,
                iconColor: const Color(0xFFDC2626),
                iconBg: const Color(0xFFFEF2F2),
                label: 'Out of Stock',
                value: '$outOfStockCount',
                badge: 'Urgent',
                borderColor: const Color(0xFFDC2626),
              ),
              const SizedBox(height: 28),
              _RecentUpdatesSection(items: recentUpdates),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
              Text(
                'Overview of your current stock and recent activities.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
        const NotificationBell(),
      ],
    );
  }
}

class _RecentUpdatesSection extends StatelessWidget {
  final List items;

  const _RecentUpdatesSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Updates',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('No recent updates',
                style: GoogleFonts.inter(color: const Color(0xFF718096))),
          )
        else
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _RecentTile(item: item),
              )),
      ],
    );
  }
}

class _RecentTile extends StatelessWidget {
  final dynamic item;

  const _RecentTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isAddition = item.change > 0;
    final statusColor = isAddition ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: statusColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
                isAddition ? Icons.add_circle_outline : Icons.remove_circle_outline,
                color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(item.timestamp),
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF718096)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isAddition ? '+' : ''}${item.change}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
