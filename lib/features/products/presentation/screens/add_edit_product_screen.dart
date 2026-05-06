import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/product_model.dart';
import '../../providers/products_provider.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  ConsumerState<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _qtyController;
  late TextEditingController _maxQtyController;
  late TextEditingController _thresholdController;
  late TextEditingController _unitController;

  String _category = 'Consumables';
  final List<String> _categories = [
    'Consumables',
    'Glassware',
    'Chemicals',
    'Equipment',
    'Packaging'
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _qtyController = TextEditingController(text: p?.qty.toString() ?? '0');
    _maxQtyController = TextEditingController(text: p?.maxQty.toString() ?? '100');
    _thresholdController =
        TextEditingController(text: p?.threshold.toString() ?? '10');
    _unitController = TextEditingController(text: p?.unit ?? 'units');
    if (p != null && _categories.contains(p.category)) {
      _category = p.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _maxQtyController.dispose();
    _thresholdController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final product = ProductModel(
        id: widget.product?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        category: _category,
        qty: int.parse(_qtyController.text),
        maxQty: int.parse(_maxQtyController.text),
        threshold: int.parse(_thresholdController.text),
        unit: _unitController.text.trim(),
      );

      if (widget.product == null) {
        ref.read(productsProvider.notifier).addProduct(product);
      } else {
        ref.read(productsProvider.notifier).updateProduct(product);
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0D1B2A)),
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D1B2A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Product Name'),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDeco('e.g. Pipette Tips'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildLabel('Category'),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: _inputDeco(''),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Initial Qty'),
                          TextFormField(
                            controller: _qtyController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDeco('0'),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (int.tryParse(v) == null) return 'Invalid';
                              if (int.parse(v) < 0) return 'Cannot be negative';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Unit'),
                          TextFormField(
                            controller: _unitController,
                            decoration: _inputDeco('e.g. ml, units'),
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Max Qty Capacity'),
                          TextFormField(
                            controller: _maxQtyController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDeco('100'),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (int.tryParse(v) == null) return 'Invalid';
                              if (int.parse(v) < 1) return '> 0';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Low Stock Threshold'),
                          TextFormField(
                            controller: _thresholdController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDeco('10'),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (int.tryParse(v) == null) return 'Invalid';
                              if (int.parse(v) < 0) return 'Cannot be negative';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3A6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Save Product',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF4A5568),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A3A6B), width: 2),
      ),
    );
  }
}
