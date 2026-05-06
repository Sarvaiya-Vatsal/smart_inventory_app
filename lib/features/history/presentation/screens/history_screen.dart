import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final List<Map<String, dynamic>> _history = const [
    {
      'name': 'Nitril Gloves',
      'date': 'Oct 24, 10:30 AM',
      'change': 20,
    },
    {
      'name': 'Beakers',
      'date': 'Oct 23, 2:15 PM',
      'change': -5,
    },
    {
      'name': 'Petri Dishes',
      'date': 'Oct 22, 9:00 AM',
      'change': 50,
    },
    {
      'name': 'Ethanol',
      'date': 'Oct 21, 4:45 PM',
      'change': -50,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock History',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D1B2A),
                          ),
                        ),
                        Text(
                          'Review recent inventory movements.',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF718096)),
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 80),
                itemCount: _history.length,
                itemBuilder: (_, i) =>
                    _HistoryItem(item: _history[i], isLast: i == _history.length - 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isLast;

  const _HistoryItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isIncrease = (item['change'] as int) > 0;
    final dotColor =
        isIncrease ? const Color(0xFF1A3A6B) : const Color(0xFFDC2626);
    final changeBg =
        isIncrease ? const Color(0xFFEBF0FF) : const Color(0xFFFEE2E2);
    final changeColor =
        isIncrease ? const Color(0xFF1A3A6B) : const Color(0xFFDC2626);
    final changeText = isIncrease
        ? '+${item['change']} units'
        : '${item['change']} units';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFFCBD5E0)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
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
                    Text(
                      item['name'],
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 13, color: Color(0xFF718096)),
                        const SizedBox(width: 4),
                        Text(
                          item['date'],
                          style: GoogleFonts.inter(
                              fontSize: 12, color: const Color(0xFF718096)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: changeBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isIncrease
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 16,
                            color: changeColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            changeText,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: changeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
