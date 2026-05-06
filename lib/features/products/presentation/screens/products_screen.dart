import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _products = const [
    {
      'name': 'Pipette Tips',
      'category': 'Consumables',
      'unit': '200ul',
      'qty': 150,
      'max': 1000,
      'threshold': 200,
      'status': 'Low Stock',
    },
    {
      'name': 'Beakers',
      'category': 'Glassware',
      'unit': '500ml',
      'qty': 85,
      'max': 100,
      'threshold': 20,
      'status': 'Optimal',
    },
    {
      'name': 'Ethanol',
      'category': 'Chemicals',
      'unit': '99% Pure',
      'qty': 0,
      'max': 50,
      'threshold': 10,
      'status': 'Out of Stock',
    },
    {
      'name': 'Petri Dishes',
      'category': 'Consumables',
      'unit': '90mm',
      'qty': 420,
      'max': 500,
      'threshold': 50,
      'status': 'Optimal',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D1B2A),
                          ),
                        ),
                        Text(
                          'Manage your warehouse inventory',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: const Color(0xFF718096)),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list_rounded, size: 16),
                    label: const Text('Filter'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D1B2A),
                      side: const BorderSide(color: Color(0xFFCBD5E0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products, categories...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFFADB5BD)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _ProductCard(item: _products[i]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A3A6B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ProductCard({required this.item});

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
            color: Colors.black.withOpacity(0.05),
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
                  color: color.withOpacity(0.12),
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
              _StatusIcon(status: item['status']),
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
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final String status;

  const _StatusIcon({required this.status});

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
