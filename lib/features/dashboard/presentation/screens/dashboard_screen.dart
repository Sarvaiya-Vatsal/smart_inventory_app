import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              _StatCard(
                icon: Icons.grid_view_rounded,
                iconColor: const Color(0xFF1A56DB),
                iconBg: const Color(0xFFEBF0FF),
                label: 'Total Products',
                value: '124',
                badge: 'All Warehouses',
                borderColor: const Color(0xFF1A56DB),
              ),
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFFF7ED),
                label: 'Low Stock Items',
                value: '12',
                badge: 'Requires Action',
                borderColor: const Color(0xFFD97706),
              ),
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.update_rounded,
                iconColor: const Color(0xFF1A56DB),
                iconBg: const Color(0xFFEBF0FF),
                label: 'Recently Updated',
                value: '5',
                badge: 'Today',
                borderColor: const Color(0xFF1A56DB),
              ),
              const SizedBox(height: 28),
              _RecentUpdatesSection(),
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
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: Color(0xFF0D1B2A)),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final String badge;
  final Color borderColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.badge,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A5568),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentUpdatesSection extends StatelessWidget {
  final List<Map<String, dynamic>> _items = const [
    {
      'name': 'Nitril Gloves',
      'category': 'Lab Supplies',
      'qty': '45 units',
      'status': 'Normal',
      'color': Color(0xFF16A34A),
    },
    {
      'name': 'Beakers 500ml',
      'category': 'Lab Supplies',
      'qty': '120 units',
      'status': 'Normal',
      'color': Color(0xFF16A34A),
    },
    {
      'name': 'Cardboard Boxes L',
      'category': 'Packaging',
      'qty': '18 units',
      'status': 'Low',
      'color': Color(0xFFD97706),
    },
  ];

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
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A3A6B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RecentTile(item: item),
            )),
      ],
    );
  }
}

class _RecentTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const _RecentTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = item['color'] as Color;
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
            child: const Icon(Icons.science_outlined,
                color: Color(0xFF4A5568), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                Text(
                  item['category'],
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
                item['qty'],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['status'],
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
