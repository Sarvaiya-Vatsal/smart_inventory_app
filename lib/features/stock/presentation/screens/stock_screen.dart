import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3A6B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 48,
                  color: Color(0xFF1A3A6B),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Stock Update',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adjust stock quantities for\nyour inventory products.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
