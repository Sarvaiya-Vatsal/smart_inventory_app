import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController _quantityController =
      TextEditingController(text: '0');

  final List<Map<String, dynamic>> _products = const [
    {
      'name': 'Pipette Tips',
      'qty': 150,
      'location': 'Warehouse A',
    },
    {
      'name': 'Beakers 500ml',
      'qty': 85,
      'location': 'Warehouse B',
    },
    {
      'name': 'Nitril Gloves',
      'qty': 45,
      'location': 'Warehouse A',
    },
    {
      'name': 'Petri Dishes',
      'qty': 420,
      'location': 'Warehouse C',
    },
    {
      'name': 'Ethanol',
      'qty': 0,
      'location': 'Warehouse B',
    },
  ];

  Map<String, dynamic>? _selectedProduct;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleStockIn() {
    if (_selectedProduct == null) {
      _showSnack('Please select a product first', const Color(0xFFD97706));
      return;
    }
    final qty = int.tryParse(_quantityController.text) ?? 0;
    if (qty <= 0) {
      _showSnack('Enter a valid quantity', const Color(0xFFD97706));
      return;
    }
    setState(() {
      final idx =
          _products.indexWhere((p) => p['name'] == _selectedProduct!['name']);
      if (idx != -1) {
        _selectedProduct = {
          ..._selectedProduct!,
          'qty': (_selectedProduct!['qty'] as int) + qty,
        };
      }
      _quantityController.text = '0';
    });
    _showSnack('Stock In: +$qty units added', const Color(0xFF16A34A));
  }

  void _handleStockOut() {
    if (_selectedProduct == null) {
      _showSnack('Please select a product first', const Color(0xFFD97706));
      return;
    }
    final qty = int.tryParse(_quantityController.text) ?? 0;
    if (qty <= 0) {
      _showSnack('Enter a valid quantity', const Color(0xFFD97706));
      return;
    }
    if (qty > (_selectedProduct!['qty'] as int)) {
      _showSnack('Insufficient stock', const Color(0xFFDC2626));
      return;
    }
    setState(() {
      _selectedProduct = {
        ..._selectedProduct!,
        'qty': (_selectedProduct!['qty'] as int) - qty,
      };
      _quantityController.text = '0';
    });
    _showSnack('Stock Out: -$qty units removed', const Color(0xFFDC2626));
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

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
              const SizedBox(height: 8),
              Text(
                'Update Stock',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
              Text(
                'Adjust inventory levels for individual products.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SELECT PRODUCT',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, dynamic>>(
                          value: _selectedProduct,
                          hint: Text(
                            'Choose an item...',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: const Color(0xFF4A5568),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF1A3A6B),
                            size: 24,
                          ),
                          isExpanded: true,
                          items: _products
                              .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(
                                      p['name'],
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        color: const Color(0xFF0D1B2A),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedProduct = v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEEAF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CURRENT STATUS',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedProduct != null
                                      ? 'Available in ${_selectedProduct!['location']}'
                                      : 'Available in Warehouse A',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4A5568),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _selectedProduct != null
                                      ? '${_selectedProduct!['qty']}'
                                      : '45',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                TextSpan(
                                  text: ' units',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'UPDATE QUANTITY',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF0D1B2A),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF1A3A6B), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the exact amount to add or remove.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _handleStockIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3A6B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline_rounded,
                            size: 20),
                        label: Text(
                          'Stock In',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _handleStockOut,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB91C1C),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                            Icons.remove_circle_outline_rounded,
                            size: 20),
                        label: Text(
                          'Stock Out',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
