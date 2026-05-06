import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Low Stock', 'Out of Stock', 'Optimal'];

  final List<Map<String, dynamic>> _results = const [
    {
      'name': 'Test Tubes',
      'sku': 'TT-1002',
      'category': 'Lab Glassware',
      'qty': 45,
      'max': 500,
      'status': 'Low Stock',
    },
    {
      'name': 'Microscope Slides',
      'sku': 'MS-504',
      'category': 'Disposables',
      'qty': 1200,
      'max': 2000,
      'status': 'Optimal',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Products',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scan barcode, enter SKU, or type product name.',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: const Color(0xFF718096)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'e.g., Test Tubes, Slides...',
                                hintStyle: GoogleFonts.inter(
                                    color: const Color(0xFFADB5BD),
                                    fontSize: 14),
                                prefixIcon: const Icon(Icons.search_rounded,
                                    color: Color(0xFFADB5BD)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(Icons.qr_code_scanner_rounded,
                                color: const Color(0xFF1A3A6B), size: 24),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedFilter = 'All';
                      _controller.clear();
                    }),
                    child: Text(
                      'Clear',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A3A6B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return _FilterChip(
                        label: 'Category',
                        isSelected: false,
                        isDropdown: true,
                        onTap: () {});
                  }
                  final f = _filters[i - 1];
                  return _FilterChip(
                    label: f,
                    isSelected: _selectedFilter == f,
                    onTap: () => setState(() => _selectedFilter = f),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _SearchResultCard(item: _results[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDropdown;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A3A6B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1A3A6B)
                : const Color(0xFFCBD5E0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF4A5568),
              ),
            ),
            if (isDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF4A5568),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _SearchResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isLow = item['status'] == 'Low Stock';
    final isOut = item['status'] == 'Out of Stock';
    final borderColor = isOut
        ? const Color(0xFFDC2626)
        : isLow
            ? const Color(0xFFD97706)
            : const Color(0xFF16A34A);
    final badgeColor = isOut
        ? const Color(0xFFDC2626)
        : isLow
            ? const Color(0xFFD97706)
            : const Color(0xFF1A3A6B);
    final badgeBg = isOut
        ? const Color(0xFFFEE2E2)
        : isLow
            ? const Color(0xFFFFF7ED)
            : const Color(0xFFEBF0FF);
    final badgeText = isOut
        ? 'OUT OF STOCK'
        : isLow
            ? 'LOW'
            : 'IN STOCK';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          color: badgeColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      badgeText,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.science_outlined,
                    size: 18, color: Color(0xFF4A5568)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item['name'],
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D1B2A),
            ),
          ),
          Text(
            'SKU: ${item['sku']} • ${item['category']}',
            style: GoogleFonts.inter(
                fontSize: 12, color: const Color(0xFF718096)),
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AVAILABLE QTY',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9CA3AF),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item['qty']}',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: isOut || isLow
                                ? badgeColor
                                : const Color(0xFF0D1B2A),
                          ),
                        ),
                        TextSpan(
                          text: ' / ${item['max']}',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isLow || isOut)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    foregroundColor: const Color(0xFF0D1B2A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Restock',
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                )
              else
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 12, color: Color(0xFF1A3A6B)),
                  label: Text(
                    'Details',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A3A6B),
                    ),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
