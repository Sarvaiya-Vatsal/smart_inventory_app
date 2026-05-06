import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../providers/search_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final currentFilter = ref.watch(searchFilterProvider);

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
                          'Search & Filter',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D1B2A),
                          ),
                        ),
                        Text(
                          'Find specific items in your inventory',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: const Color(0xFF718096)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3A6B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.qr_code_scanner_rounded,
                          color: Color(0xFF1A3A6B)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) =>
                    ref.read(searchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Search by name or category...',
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
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: currentFilter == 'All',
                    onTap: () =>
                        ref.read(searchFilterProvider.notifier).state = 'All',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Low Stock',
                    isSelected: currentFilter == 'Low Stock',
                    onTap: () => ref
                        .read(searchFilterProvider.notifier)
                        .state = 'Low Stock',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Out of Stock',
                    isSelected: currentFilter == 'Out of Stock',
                    onTap: () => ref
                        .read(searchFilterProvider.notifier)
                        .state = 'Out of Stock',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Optimal',
                    isSelected: currentFilter == 'Optimal',
                    onTap: () => ref
                        .read(searchFilterProvider.notifier)
                        .state = 'Optimal',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Consumables',
                    isSelected: currentFilter == 'Consumables',
                    onTap: () => ref
                        .read(searchFilterProvider.notifier)
                        .state = 'Consumables',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                      child: Text('No matching products found.',
                          style: GoogleFonts.inter(
                              color: const Color(0xFF718096))))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final product = filteredProducts[i];
                        return ProductCard(
                          item: {
                            'id': product.id,
                            'name': product.name,
                            'category': product.category,
                            'unit': product.unit,
                            'qty': product.qty,
                            'max': product.maxQty,
                            'threshold': product.threshold,
                            'status': product.status,
                          },
                        );
                      },
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
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
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
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF4A5568),
            ),
          ),
        ),
      ),
    );
  }
}
